import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task2/presentation/music_screen/model/music_model.dart';
import 'package:task2/presentation/music_screen/view/playlist_screen.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      body: Stack(
        children: [
          Positioned(
            bottom: -size.width * 0.2,
            left: size.width * 0.15,
            child: Stack(
              children: [
                Container(
                  width: size.width * 0.7,
                  height: size.width * 0.7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0xff3579DD), Colors.transparent],
                      radius: 15,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 353.96, sigmaY: 353.96),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.02),
                  Text(
                    "Share your Music",
                    style: GoogleFonts.urbanist(
                      color: Colors.white,
                      fontSize: fontSize * 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "What do you feel like today?",
                    style: GoogleFonts.urbanist(
                      color: Colors.white54,
                      fontSize: fontSize * 0.8,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white54),
                        SizedBox(width: padding),
                        Expanded(
                          child: TextField(
                            style: GoogleFonts.urbanist(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Search song, playlist, artist...",
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontSize: fontSize * 0.8,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  SizedBox(
                    height: size.height * 0.3,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dummyPlaylists.length,
                      itemBuilder: (context, index) {
                        Playlist playlist = dummyPlaylists[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        PlaylistScreen(playlist: playlist),
                              ),
                            );
                          },
                          child: Container(
                            width: size.width * 0.5,
                            margin: EdgeInsets.only(right: padding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: size.height * 0.2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: AssetImage(playlist.imagePath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  playlist.name,
                                  style: GoogleFonts.urbanist(
                                    color: Colors.white,
                                    fontSize: fontSize * 0.9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  playlist.description,
                                  style: GoogleFonts.urbanist(
                                    color: Colors.white54,
                                    fontSize: fontSize * 0.7,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    "Your favourites",
                    style: GoogleFonts.urbanist(
                      color: Colors.white,
                      fontSize: fontSize,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  dummyFavouriteSongs.isNotEmpty
                      ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dummyFavouriteSongs.length,
                        itemBuilder: (context, index) {
                          Song song = dummyFavouriteSongs[index];
                          return ListTile(
                            leading: Image.asset(song.imagePath),
                            title: Text(
                              song.title,
                              style: GoogleFonts.urbanist(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize * 0.8,
                              ),
                            ),
                            subtitle: Text(
                              song.artist,
                              style: GoogleFonts.urbanist(
                                color: Colors.white54,
                                fontSize: fontSize * 0.75,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Text(
                              song.duration,
                              style: GoogleFonts.urbanist(
                                color: Colors.white54,
                                fontSize: fontSize * 0.7,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      )
                      : Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.1,
                          ),
                          child: Text(
                            "No favourite songs yet!",
                            style: GoogleFonts.urbanist(
                              color: Colors.white54,
                              fontSize: fontSize * 0.9,
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
