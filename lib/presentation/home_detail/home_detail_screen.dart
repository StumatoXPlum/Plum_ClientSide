import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../home_screen/model/report_model.dart';
import '../saved_screen/cubit/save_cubit.dart';
import 'video_player.dart';

class HomeDetailScreen extends StatefulWidget {
  final ReportModel report;
  const HomeDetailScreen({super.key, required this.report});

  @override
  State<HomeDetailScreen> createState() => _HomeDetailScreenState();
}

class _HomeDetailScreenState extends State<HomeDetailScreen> {
  List<String> mediaList = [];
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    mediaList = widget.report.media;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;

    return Scaffold(
      backgroundColor: Color(0xff1F265E),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(padding),
                    bottomRight: Radius.circular(padding),
                  ),
                  child: SizedBox(
                    height: size.height * 0.35,
                    width: double.infinity,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: mediaList.length,
                      itemBuilder: (context, index) {
                        final url = mediaList[index];
                        if (url.endsWith(".mp4")) {
                          return VideoPlayerWidget(videoUrl: url);
                        } else {
                          return Image.network(url, fit: BoxFit.cover);
                        }
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.03,
                  left: padding,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.03,
                  right: padding,
                  child: BlocBuilder<SaveCubit, List<ReportModel>>(
                    builder: (context, savedReports) {
                      bool isSaved = savedReports.any(
                        (r) => r.id == widget.report.id,
                      );
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon:
                              isSaved
                                  ? Icon(Icons.favorite, color: Colors.red)
                                  : Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                  ),
                          onPressed: () {
                            context.read<SaveCubit>().toggleSaveReport(
                              widget.report,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            if (mediaList.length > 1)
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.015),
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: mediaList.length,
                    effect: const WormEffect(
                      dotColor: Colors.white38,
                      activeDotColor: Colors.white,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 6,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding,
                      vertical: padding,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      border: Border.all(color: const Color(0xff8E97FD)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.report.title,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: fontSize * 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.report.date,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: fontSize * 0.9,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding,
                      vertical: padding,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      border: Border.all(color: const Color(0xff8E97FD)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.report.subtitle,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: fontSize * 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          widget.report.description,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: fontSize * 0.9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
