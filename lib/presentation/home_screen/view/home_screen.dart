import '../../home_detail/home_detail_screen.dart';
import '../model/report_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ReportModel> reports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase.from('reports').select();
      final data = response as List;

      final fetchedReports =
          data.map((reportJson) {
            return ReportModel.fromJson(reportJson);
          }).toList();

      setState(() {
        reports = fetchedReports;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;

    return Scaffold(
      backgroundColor: const Color(0xff1F265E),
      body: RefreshIndicator(
        color: const Color(0xff8E97FD),
        onRefresh: fetchReports,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  "assets/home_assets/header.svg",
                  fit: BoxFit.contain,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
                  child: Column(
                    children: [
                      Text(
                        "Aloha Daily",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: fontSize * 1.8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Your curated summary of key market insights and trends to empower your financial journey.",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: fontSize * 0.8,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: Image.asset("assets/home_assets/header2.png"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding * 1.1),
                  child: Column(
                    children: [
                      Text(
                        "Aloha Funds",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: fontSize * 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        "Your gateway to smart investing—empowered by daily market insights.",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: fontSize,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: size.height * 0.02),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: padding,
                            vertical: padding * 0.6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(38),
                          ),
                          child: Text(
                            'START',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            if (isLoading)
              SizedBox(
                height: size.height * 0.4,
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xff8E97FD)),
                ),
              )
            else if (reports.isEmpty)
              SizedBox(
                height: size.height * 0.4,
                child: Center(
                  child: Text(
                    "No reports found",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: fontSize,
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: reports.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: size.width * 0.04,
                    mainAxisExtent: size.height * 0.22,
                  ),
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => HomeDetailScreen(report: report),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              height: size.height * 0.15,
                              width: double.infinity,
                              report.media.isNotEmpty ? report.media[0] : '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image);
                              },
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Expanded(
                            child: Text(
                              report.title,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.002),
                          Expanded(
                            child: Text(
                              report.date,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: fontSize * 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
