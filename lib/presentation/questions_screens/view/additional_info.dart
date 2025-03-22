import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task2/core/custom_widgets/custom_button.dart';
import 'package:task2/presentation/questions_screens/view/on_submit_screen.dart';
import 'package:task2/presentation/questions_screens/widgets/progress_bar.dart';

class AdditionalInfoScreen extends StatefulWidget {
  const AdditionalInfoScreen({super.key});

  @override
  AdditionalInfoScreenState createState() => AdditionalInfoScreenState();
}

class AdditionalInfoScreenState extends State<AdditionalInfoScreen> {
  final TextEditingController _additionalInfoController =
      TextEditingController();

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
          "Group Preference",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomProgressBar(progress: 1.0),
              SizedBox(height: size.height * 0.02),
              Text(
                "Do you have any additional information or special requirements?",
                style: GoogleFonts.urbanist(
                  fontSize: fontSize * 1.2,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Expanded(
                child: TextField(
                  cursorColor: Colors.white,
                  style: GoogleFonts.urbanist(color: Colors.white),
                  controller: _additionalInfoController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: "Enter details",
                    labelStyle: GoogleFonts.urbanist(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xff3579DD)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: padding * 1.5),
                child: CustomButton(
                  buttonText: "Submit",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnSubmitScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _additionalInfoController.dispose();
    super.dispose();
  }
}
