import 'dart:io';
import '../../../core/custom_widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../report_details/view/report_details_screen.dart';
import '../cubit/media_cubit.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _mediaFiles = [];
  final List<VideoPlayerController?> _videoControllers = [];

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_mediaFiles.length >= 10) {
      _showLimitReachedSnackBar();
      return;
    }

    final List<XFile> pickedImages = await _picker.pickMultiImage();
    if (pickedImages.isNotEmpty) {
      int availableSlots = 10 - _mediaFiles.length;
      List<XFile> imagesToAdd = pickedImages.take(availableSlots).toList();

      setState(() {
        _mediaFiles.addAll(imagesToAdd.map((file) => File(file.path)));
        _videoControllers.addAll(List.filled(imagesToAdd.length, null));
      });

      if (pickedImages.length > availableSlots) {
        _showLimitReachedSnackBar();
      }
    }
  }

  Future<void> _pickVideo() async {
    if (_mediaFiles.length >= 10) {
      _showLimitReachedSnackBar();
      return;
    }

    final XFile? pickedVideo = await _picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (pickedVideo != null) {
      setState(() {
        _mediaFiles.add(File(pickedVideo.path));
        _videoControllers.add(
          VideoPlayerController.file(File(pickedVideo.path))
            ..initialize().then((_) {
              setState(() {});
            }),
        );
      });
    }
  }

  void _showLimitReachedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "You can only upload up to 10 media files.",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _removeMedia(int index) {
    setState(() {
      _mediaFiles.removeAt(index);
      _videoControllers[index]?.dispose();
      _videoControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;
    return Scaffold(
      backgroundColor: const Color(0xff1F265E),
      appBar: AppBar(
        backgroundColor: const Color(0xff1F265E),
        foregroundColor: Colors.white,
        title: Text(
          "Pick Media",
          style: GoogleFonts.poppins(fontSize: fontSize * 1.5),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.8,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  if (index < _mediaFiles.length) {
                    File file = _mediaFiles[index];
                    VideoPlayerController? controller =
                        _videoControllers[index];
                    bool isVideo =
                        file.path.endsWith(".mp4") ||
                        file.path.endsWith(".mov");

                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              isVideo &&
                                      controller != null &&
                                      controller.value.isInitialized
                                  ? AspectRatio(
                                    aspectRatio: controller.value.aspectRatio,
                                    child: VideoPlayer(controller),
                                  )
                                  : Image.file(
                                    file,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                        ),
                        if (isVideo)
                          Positioned(
                            bottom: 5,
                            left: 5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (controller.value.isPlaying) {
                                    controller.pause();
                                  } else {
                                    controller.play();
                                  }
                                });
                              },
                              child: CircleAvatar(
                                radius: size.width * 0.04,
                                backgroundColor: Colors.black54,
                                child: Icon(
                                  controller!.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeMedia(index),
                            child: CircleAvatar(
                              radius: fontSize * 0.8,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                size: fontSize,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return GestureDetector(
                      onTap: () {
                        if (_mediaFiles.length < 10) _pickImages();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: const Center(
                          child: Icon(Icons.add_a_photo, color: Colors.white54),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.image),
                  label: Text(
                    "Pick Images",
                    style: GoogleFonts.poppins(fontSize: fontSize),
                  ),
                ),
                SizedBox(width: size.width * 0.03),
                ElevatedButton.icon(
                  onPressed: _pickVideo,
                  icon: const Icon(Icons.video_collection),
                  label: Text(
                    "Pick Video",
                    style: GoogleFonts.poppins(fontSize: fontSize),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: ButtonWidget(
              buttonText: "Next",
              onTap: () {
                if (_mediaFiles.isNotEmpty) {
                  context.read<MediaCubit>().addMediaFiles(_mediaFiles);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportDetailsScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Please select at least one media file.",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
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
    );
  }
}
