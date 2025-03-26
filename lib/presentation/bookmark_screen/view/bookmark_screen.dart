import 'package:flutter/cupertino.dart';
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
    final double fontSize = size.width * 0.045;

    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      appBar: AppBar(
        title: Text(
          "Saved Events",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: bookmarkedEvents.length,
            itemBuilder: (context, index) {
              final event = bookmarkedEvents[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
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
                        child: Image.network(
                          event.imageUrl,
                          fit: BoxFit.cover,
                          width: size.width * 0.9,
                          height: size.height * 0.24,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.broken_image,
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 10,
                        child: BlocListener<BookmarkCubit, List<EventModel>>(
                          listener: (context, state) {},
                          child: GestureDetector(
                            onTap: () {
                              context.read<BookmarkCubit>().toggleBookmark(
                                event,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
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
                      ),
                      Positioned(
                        bottom: 5,
                        left: 5,
                        right: 5,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xff0A0A0A),
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
                              const SizedBox(height: 4),
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
