import '../../home_detail/home_detail_screen.dart';
import '../cubit/save_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../home_screen/model/report_model.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;
    return Scaffold(
      backgroundColor: Color(0xff1F265E),
      appBar: AppBar(
        title: Text(
          "Saved Reports",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: fontSize * 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff1F265E),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<SaveCubit, List<ReportModel>>(
        builder: (context, savedReports) {
          if (savedReports.isEmpty) {
            return Center(
              child: Text(
                "No Saved Reports",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: ListView.builder(
              itemCount: savedReports.length,
              itemBuilder: (context, index) {
                final report = savedReports[index];
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: padding,
                    vertical: padding,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff8E97FD),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xff7C88E8), width: 2),
                  ),
                  margin: EdgeInsets.symmetric(vertical: padding * 0.7),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => HomeDetailScreen(report: report),
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            report.media.isNotEmpty ? report.media[0] : '',
                            width: size.width * 0.2,
                            height: size.height * 0.08,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                report.title,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: fontSize * 1.2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: size.height * 0.001),
                              Text(
                                report.date,
                                style: GoogleFonts.poppins(
                                  fontSize: fontSize * 0.8,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Color(0xff1F265E)),
                          onPressed: () {
                            context.read<SaveCubit>().removeReport(report.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
