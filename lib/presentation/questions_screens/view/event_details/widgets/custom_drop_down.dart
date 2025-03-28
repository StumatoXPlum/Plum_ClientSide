import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final Map<String, List<Map<String, dynamic>>> options;
  final ValueChanged<String> onOccasionChanged;

  const CustomDropdown({
    super.key,
    required this.questions,
    required this.options,
    required this.onOccasionChanged,
  });

  @override
  CustomDropdownState createState() => CustomDropdownState();
}

class CustomDropdownState extends State<CustomDropdown> {
  String? _selectedOccasion;
  bool _showCustomOccasionField = false;

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return const SizedBox();
    }

    var occasionQuestion = widget.questions.firstWhere(
      (q) => q['question_text'] == 'Occasion',
      orElse: () => {},
    );

    if (occasionQuestion.isEmpty) {
      return const SizedBox();
    }

    List<Map<String, dynamic>> occasionOptions =
        widget.options[occasionQuestion['id'].toString()] ?? [];

    return Column(
      children: [
        DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<String>(
              dropdownColor: const Color(0xff161C25),
              value: _selectedOccasion,
              style: GoogleFonts.urbanist(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Occasion",
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
              items:
                  occasionOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option['option_text'] as String,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Text(
                          option['option_text'] as String,
                          style: GoogleFonts.urbanist(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedOccasion = value;
                  widget.onOccasionChanged(value ?? "");
                  _showCustomOccasionField = value == "Other";
                });
              },
              alignment: Alignment.centerLeft,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        if (_showCustomOccasionField)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Enter Custom Occasion",
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
              style: GoogleFonts.urbanist(color: Colors.white),
              onChanged: widget.onOccasionChanged,
            ),
          ),
      ],
    );
  }
}
