import 'dart:math';
import 'dart:ui';
import 'package:aloha_funds/admin/description_screen/cubit/description_cubit.dart';
import 'package:aloha_funds/admin/image_picker/cubit/media_cubit.dart';
import 'package:aloha_funds/admin/report_details/cubit/report_details_cubit.dart';
import 'package:aloha_funds/admin/view_report/widgets/success.dart';
import 'package:aloha_funds/admin/view_report/widgets/uploading.dart';
import 'package:aloha_funds/core/custom_widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ViewReportScreen extends StatefulWidget {
  const ViewReportScreen({super.key});

  @override
  State<ViewReportScreen> createState() => _ViewReportScreenState();
}

class _ViewReportScreenState extends State<ViewReportScreen> {
  void showUploadingDialog(
    BuildContext context,
    ValueNotifier<bool> isUploadingDone,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: ValueListenableBuilder(
                valueListenable: isUploadingDone,
                builder: (_, bool isDone, __) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder: (child, animation) {
                      final rotate = Tween(
                        begin: pi,
                        end: 0.0,
                      ).animate(animation);
                      return AnimatedBuilder(
                        animation: rotate,
                        child: child,
                        builder: (context, child) {
                          final isUnder = (ValueKey(isDone) != child?.key);
                          var tilt = (isUnder ? pi : 0.0);
                          return Transform(
                            transform: Matrix4.rotationY(tilt + rotate.value),
                            alignment: Alignment.center,
                            child: child,
                          );
                        },
                      );
                    },
                    child:
                        isDone
                            ? SuccessDialogContent(key: const ValueKey(true))
                            : UploadingDialogContent(
                              key: const ValueKey(false),
                            ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;

    final mediaState = context.watch<MediaCubit>().state;
    final detailsState = context.watch<ReportDetailsCubit>().state;
    final descriptionState = context.watch<DescriptionCubit>().state;

    return Scaffold(
      backgroundColor: const Color(0xff1F265E),
      appBar: AppBar(
        backgroundColor: const Color(0xff1F265E),
        foregroundColor: Colors.white,
        title: Text(
          "View Report",
          style: GoogleFonts.poppins(fontSize: fontSize * 1.5),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.03),
              Text(
                "Uploaded Media",
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: fontSize,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              SizedBox(
                height: size.height * 0.15,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mediaState.mediaFiles.length,
                  itemBuilder: (context, index) {
                    final file = mediaState.mediaFiles[index];
                    final isImage =
                        file.path.endsWith('.jpg') ||
                        file.path.endsWith('.jpeg') ||
                        file.path.endsWith('.png');

                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:
                            isImage
                                ? Image.file(
                                  file,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                                : Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.black38,
                                  child: const Icon(
                                    Icons.videocam,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: size.height * 0.03),
              _buildLabel(context, "Title", detailsState.title),
              SizedBox(height: size.height * 0.03),
              _buildLabel(context, "Date", detailsState.date),
              SizedBox(height: size.height * 0.03),
              _buildLabel(context, "Subtitle", detailsState.subtitle),
              SizedBox(height: size.height * 0.03),
              _buildLabel(context, "Time", detailsState.time),
              SizedBox(height: size.height * 0.03),
              _buildLabel(
                context,
                "Description",
                descriptionState.isEmpty ? "N/A" : descriptionState,
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          children: [
            Expanded(
              child: ButtonWidget(
                buttonText: "Edit Report",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),

            SizedBox(width: size.width * 0.02),
            Expanded(
              child: ButtonWidget(
                buttonText: "Submit Report",
                onTap: () async {
                  final supabase = Supabase.instance.client;
                  final isUploadingDone = ValueNotifier<bool>(false);
                  showUploadingDialog(context, isUploadingDone);
                  try {
                    final title = detailsState.title;
                    final subtitle = detailsState.subtitle;
                    final date = detailsState.date;
                    final time = detailsState.time;
                    final description = descriptionState;
                    final mediaFiles = mediaState.mediaFiles;
                    List<String> mediaUrls = [];
                    for (var file in mediaFiles) {
                      final fileBytes = await file.readAsBytes();
                      final fileName =
                          'reports/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
                      await supabase.storage
                          .from('report-images')
                          .uploadBinary(
                            fileName,
                            fileBytes,
                            fileOptions: const FileOptions(
                              cacheControl: '3600',
                              upsert: false,
                            ),
                          );
                      final publicUrl = supabase.storage
                          .from('report-images')
                          .getPublicUrl(fileName);
                      mediaUrls.add(publicUrl);
                    }
                    await supabase.from('reports').insert({
                      'id': const Uuid().v4(),
                      'title': title,
                      'subtitle': subtitle,
                      'date': date,
                      'time': time,
                      'description': description,
                      'image': mediaUrls,
                    });
                    await Future.delayed(Duration(seconds: 5));
                    context.read<MediaCubit>().clearMedia();
                    context.read<ReportDetailsCubit>().clear();
                    context.read<DescriptionCubit>().updateDescription('');

                    isUploadingDone.value = true;
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Failed to submit report: $e",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        backgroundColor: Colors.red.shade600,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(context, String label, String value) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white60, fontSize: fontSize),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white10,
            border: Border.all(color: Color(0xff8E97FD)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value.isEmpty ? 'N/A' : value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
