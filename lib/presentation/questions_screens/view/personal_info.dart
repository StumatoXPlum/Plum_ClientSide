import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task2/presentation/questions_screens/widgets/custom_text_field.dart';
import '../../../core/custom_widgets/custom_button.dart';
import '../widgets/progress_bar.dart';

class PersonalInfo extends StatefulWidget {
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
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    contactNumberController.dispose();
    emailController.dispose();
    super.dispose();
  }

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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
            CustomTextField(
              label: "Full Name",
              controller: fullNameController,
              keyboardType: TextInputType.text,
              onChanged: widget.onFullNameChanged,
            ),
            SizedBox(height: size.height * 0.02),
            CustomTextField(
              label: "Contact Number",
              controller: contactNumberController,
              keyboardType: TextInputType.phone,
              onChanged: widget.onContactNumberChanged,
            ),
            SizedBox(height: size.height * 0.02),
            CustomTextField(
              label: "Email Address",
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: widget.onEmailChanged,
            ),
            SizedBox(height: size.height * 0.02),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(padding),
        child: CustomButton(buttonText: "Next", onTap: widget.goToNext),
      ),
    );
  }
}
