import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.keyboardType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: Colors.white,
      style: GoogleFonts.urbanist(color: Colors.white),
      onChanged: onChanged,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.urbanist(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xff161C25),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff202938)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF3579DD)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
