import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBack;

  const CustomAppBar({super.key, required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double fontSize = size.width * 0.05;
    return AppBar(
      backgroundColor: const Color(0xff090D14),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: fontSize * 1.2,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
