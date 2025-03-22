import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task2/core/custom_widgets/custom_button.dart';
import 'package:task2/presentation/questions_screens/view/preferred_location.dart';
import 'package:task2/presentation/questions_screens/widgets/progress_bar.dart';

class PreferredDJScreen extends StatefulWidget {
  const PreferredDJScreen({super.key});

  @override
  PreferredDJScreenState createState() => PreferredDJScreenState();
}

class PreferredDJScreenState extends State<PreferredDJScreen> {
  String? _selectedDJ;
  final TextEditingController _otherDJController = TextEditingController();

  final List<Map<String, dynamic>> _djOptions = [
    {"value": "dj_mirage", "label": "DJ Mirage"},
    {"value": "dj_zenith", "label": "DJ Zenith"},
    {"value": "dj_aurora", "label": "DJ Aurora"},
    {"value": "other", "label": "Other", "input": true},
  ];

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
            children: [
              CustomProgressBar(progress: 0.6),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.02),
                      Text(
                        "Who is your preferred DJ?",
                        style: GoogleFonts.urbanist(
                          fontSize: fontSize * 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Column(
                        children:
                            _djOptions
                                .map((option) => _buildRadioButton(option))
                                .toList(),
                      ),
                      if (_selectedDJ == "other")
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextField(
                            controller: _otherDJController,
                            cursorColor: Colors.white,
                            style: GoogleFonts.urbanist(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Enter DJ name",
                              labelStyle: GoogleFonts.urbanist(
                                color: Colors.white70,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xff3579DD),
                                ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: size.height * 0.02),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: padding * 1.5),
                child: CustomButton(
                  buttonText: "Next",
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => PreferredLocationScreen(),
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

  Widget _buildRadioButton(Map<String, dynamic> option) {
    return RadioListTile<String>(
      title: Text(
        option['label']!,
        style: GoogleFonts.urbanist(color: Colors.white, fontSize: 16),
      ),
      value: option['value'],
      groupValue: _selectedDJ,
      onChanged: (String? value) {
        setState(() {
          _selectedDJ = value;
        });
      },
      activeColor: Color(0xff3579DD),
    );
  }

  @override
  void dispose() {
    _otherDJController.dispose();
    super.dispose();
  }
}
