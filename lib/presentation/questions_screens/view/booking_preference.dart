import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task2/core/custom_widgets/custom_button.dart';
import 'package:task2/presentation/questions_screens/view/preferred_dj.dart';
import 'package:task2/presentation/questions_screens/widgets/progress_bar.dart';

class BookingPreferenceScreen extends StatefulWidget {
  const BookingPreferenceScreen({super.key});

  @override
  BookingPreferenceScreenState createState() => BookingPreferenceScreenState();
}

class BookingPreferenceScreenState extends State<BookingPreferenceScreen> {
  String? _selectedPreference;

  final List<Map<String, String>> _preferences = [
    {
      "value": "event_experience",
      "label": "Event Experience – Exclusive, themed party",
    },
    {
      "value": "pub_club_experience",
      "label": "Pub/Club Experience – Relaxed, vibrant night out",
    },
    {
      "value": "nightclub_experience",
      "label": "Nightclub Experience – High-energy dance floor action",
    },
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
              CustomProgressBar(progress: 0.4),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.02),
                      Text(
                        "Select Booking Preference",
                        style: GoogleFonts.urbanist(
                          fontSize: fontSize * 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Column(
                        children:
                            _preferences
                                .map((option) => _buildRadioButton(option))
                                .toList(),
                      ),
                      SizedBox(height: size.height * 0.05),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: padding * 1.5,
                  top: padding * 1.5,
                ),
                child: CustomButton(
                  buttonText: "Next",
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const PreferredDJScreen(),
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
      groupValue: _selectedPreference,
      onChanged: (String? value) {
        setState(() {
          _selectedPreference = value;
        });
      },
      activeColor: const Color(0xff3579DD),
    );
  }
}
