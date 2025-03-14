import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../home_screen/home_detail_screen/view/new_home_detail_screen.dart';
import '../cubit/bookmark_cubit.dart';
import '../../home_screen/home_screen/model/event_model.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;

    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      appBar: AppBar(
        title: Text(
          "Saved Events",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: const Color(0xff090D14),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<BookmarkCubit, List<EventModel>>(
        builder: (context, bookmarkedEvents) {
          if (bookmarkedEvents.isEmpty) {
            return Center(
              child: Text(
                "No saved events yet",
                style: GoogleFonts.urbanist(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: padding),
            itemCount: bookmarkedEvents.length,
            itemBuilder: (context, index) {
              final event = bookmarkedEvents[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewHomeDetailScreen(event: event),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.02),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          event.imageUrl,
                          fit: BoxFit.cover,
                          width: size.width * 0.9,
                          height: size.height * 0.24,
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            context.read<BookmarkCubit>().toggleBookmark(event);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.bookmark,
                              color: Colors.white,
                              size: fontSize,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        left: 5,
                        right: 5,
                        child: Container(
                          padding: EdgeInsets.all(padding * 0.5),
                          decoration: BoxDecoration(
                            color: Color(0xff0A0A0A),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${event.title} with ${event.artist}',
                                style: GoogleFonts.urbanist(
                                  color: Colors.white,
                                  fontSize: fontSize * 0.7,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: size.height * 0.003),
                              Text(
                                '${event.date} - ${event.location}',
                                style: GoogleFonts.urbanist(
                                  color: Colors.white70,
                                  fontSize: fontSize * 0.6,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
