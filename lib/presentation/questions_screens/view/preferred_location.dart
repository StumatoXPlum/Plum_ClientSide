import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task2/core/custom_widgets/custom_button.dart';
import 'package:task2/presentation/questions_screens/view/additional_info.dart';
import 'package:task2/presentation/questions_screens/widgets/progress_bar.dart';

class PreferredLocationScreen extends StatefulWidget {
  const PreferredLocationScreen({super.key});

  @override
  PreferredLocationScreenState createState() => PreferredLocationScreenState();
}

class PreferredLocationScreenState extends State<PreferredLocationScreen> {
  String? _selectedLocation;
  final TextEditingController _otherLocationController =
      TextEditingController();

  final List<Map<String, String>> _locations = [
    {"value": "dubai_marina", "label": "Dubai Marina"},
    {"value": "jbr", "label": "JBR (Jumeirah Beach Residence)"},
    {"value": "downtown_dubai", "label": "Downtown Dubai"},
    {"value": "other", "label": "Other"},
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
              CustomProgressBar(progress: 0.8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.02),
                      Text(
                        "What is your preferred location/area in Dubai?",
                        style: GoogleFonts.urbanist(
                          fontSize: fontSize * 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Column(
                        children:
                            _locations
                                .map((option) => _buildRadioButton(option))
                                .toList(),
                      ),
                      if (_selectedLocation == "other")
                        Padding(
                          padding: EdgeInsets.only(top: padding),
                          child: TextField(
                            cursorColor: Colors.white,
                            style: GoogleFonts.urbanist(color: Colors.white),
                            controller: _otherLocationController,
                            decoration: InputDecoration(
                              labelText: "Enter other location",
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
                        builder: (context) => AdditionalInfoScreen(),
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

  Widget _buildRadioButton(Map<String, String> option) {
    return RadioListTile<String>(
      title: Text(
        option['label']!,
        style: GoogleFonts.urbanist(color: Colors.white, fontSize: 16),
      ),
      value: option['value']!,
      groupValue: _selectedLocation,
      onChanged: (String? value) {
        setState(() {
          _selectedLocation = value;
        });
      },
      activeColor: Color(0xff3579DD),
    );
  }

  @override
  void dispose() {
    _otherLocationController.dispose();
    super.dispose();
  }
}
