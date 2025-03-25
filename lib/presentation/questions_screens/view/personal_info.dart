import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/custom_widgets/custom_button.dart';
import '../widgets/progress_bar.dart';

class PersonalInfo extends StatelessWidget {
  final VoidCallback goToNext;
  final ValueChanged<String> onFullNameChanged;
  final ValueChanged<String> onContactNumberChanged;
  final ValueChanged<String> onEmailChanged;

  const PersonalInfo({
    super.key,
    required this.goToNext,
    required this.onFullNameChanged,
    required this.onContactNumberChanged,
    required this.onEmailChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      appBar: AppBar(
        backgroundColor: const Color(0xff090D14),
        title: Text(
          "Personal Information",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: fontSize * 1.2,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.02),
            CustomProgressBar(progress: 0.15),
            SizedBox(height: size.height * 0.04),
            textFieldWidget('Full Name', context, onFullNameChanged),
            SizedBox(height: size.height * 0.02),
            textFieldWidget('Contact Number', context, onContactNumberChanged),
            SizedBox(height: size.height * 0.02),
            textFieldWidget('Email Address', context, onEmailChanged),
            SizedBox(height: size.height * 0.02),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(padding),
        child: CustomButton(buttonText: "Next", onTap: goToNext),
      ),
    );
  }

  Widget textFieldWidget(String label, BuildContext context, ValueChanged<String> onChanged) {
    final Size size = MediaQuery.of(context).size;
    double fontSize = size.width * 0.05;
    return TextField(
      style: GoogleFonts.urbanist(color: Colors.white, fontSize: fontSize * 0.8),
      cursorColor: Colors.white,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      decoration: InputDecoration(
        label: Text(label),
        labelStyle: GoogleFonts.urbanist(
          color: Colors.white70,
          fontSize: fontSize * 0.8,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
