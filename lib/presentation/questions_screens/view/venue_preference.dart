import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/custom_widgets/custom_button.dart';
import '../supabase/questions_service.dart';
import '../widgets/progress_bar.dart';

class VenuePreferences extends StatefulWidget {
  final VoidCallback goToNext;
  final VoidCallback goToPrevious;
  final ValueChanged<bool?> onExclusiveVenueChanged;
  final ValueChanged<String?> onPreferredVenueTypeChanged;
  final ValueChanged<String?> onDesiredLocationChanged;

  const VenuePreferences({
    super.key,
    required this.goToNext,
    required this.goToPrevious,
    required this.onExclusiveVenueChanged,
    required this.onPreferredVenueTypeChanged,
    required this.onDesiredLocationChanged,
  });

  @override
  VenuePreferencesState createState() => VenuePreferencesState();
}

class VenuePreferencesState extends State<VenuePreferences> {
  final QuestionsService _questionsService = QuestionsService();

  List<Map<String, dynamic>> _questions = [];
  Map<String, List<Map<String, dynamic>>> _options = {};
  bool _isLoading = true;

  final TextEditingController _locationController = TextEditingController();
  bool? _exclusiveVenue;
  String? _venueType;

  @override
  void initState() {
    super.initState();
    _fetchQuestionsAndOptions();
  }

  Future<void> _fetchQuestionsAndOptions() async {
    try {
      final List<Map<String, dynamic>> questions =
          await _questionsService.fetchQuestionsWithOptions();

      Map<String, List<Map<String, dynamic>>> options = {};
      for (var question in questions) {
        options[question['id'].toString()] = List<Map<String, dynamic>>.from(
          question['options'] ?? [],
        );
      }
      setState(() {
        _questions = questions;
        _options = options;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching questions: $e");
    }
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
          "Venue Preferences",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: fontSize * 1.2,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: widget.goToPrevious,
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomProgressBar(progress: 0.5),
                    SizedBox(height: padding * 2),
                    _buildDropdown(
                      "Do you require an exclusive venue?",
                      ["Yes", "No"],
                      (value) {
                        setState(() {
                          _exclusiveVenue = value == "Yes";
                          widget.onExclusiveVenueChanged(_exclusiveVenue);
                        });
                      },
                      _exclusiveVenue != null
                          ? (_exclusiveVenue! ? "Yes" : "No")
                          : null,
                    ),

                    SizedBox(height: padding * 1.5),
                    _buildDropdown(
                      "Preferred Venue Type",
                      _getOptions("Preferred Venue Type"),
                      (value) {
                        setState(() {
                          _venueType = value;
                          widget.onPreferredVenueTypeChanged(value);
                        });
                      },
                      _venueType,
                    ),
                    SizedBox(height: padding * 1.5),
                    _buildTextField(
                      "Desired Location or Area",
                      _locationController,
                      TextInputType.text,
                    ),

                    SizedBox(height: size.height * 0.05),
                  ],
                ),
              ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(padding),
        child: CustomButton(buttonText: "Next", onTap: widget.goToNext),
      ),
    );
  }

  List<String> _getOptions(String questionText) {
    var question = _questions.firstWhere(
      (q) => q['question_text'] == questionText,
      orElse: () => {},
    );

    if (question.isNotEmpty) {
      String questionId = question['id'].toString();
      return _options[questionId]
              ?.map((option) => option['option_text'] as String)
              .toList() ??
          [];
    }
    return [];
  }

  Widget _buildDropdown(
    String label,
    List<String> options,
    Function(String?) onChanged,
    String? value,
  ) {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.black,
      value: value,
      style: GoogleFonts.urbanist(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.urbanist(color: Colors.white70),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items:
          options
              .map(
                (label) => DropdownMenuItem(
                  value: label,
                  child: Text(
                    label,
                    style: GoogleFonts.urbanist(color: Colors.white),
                  ),
                ),
              )
              .toList(),
      onChanged: (val) {
        onChanged(val);
      },
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    TextInputType keyboardType,
  ) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: Colors.white,
      style: GoogleFonts.urbanist(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.urbanist(color: Colors.white70),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
