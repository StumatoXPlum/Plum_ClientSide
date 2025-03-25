import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/custom_widgets/custom_button.dart';
import '../supabase/questions_service.dart';
import '../widgets/progress_bar.dart';

class EventDetails extends StatefulWidget {
  final VoidCallback goToNext;
  final VoidCallback goToPrevious;
  const EventDetails({
    super.key,
    required this.goToNext,
    required this.goToPrevious,
  });

  @override
  EventDetailsState createState() => EventDetailsState();
}

class EventDetailsState extends State<EventDetails> {
  final QuestionsService _questionsService = QuestionsService();

  List<Map<String, dynamic>> _questions = [];
  Map<String, List<Map<String, dynamic>>> _options = {};
  bool _isLoading = true;

  final TextEditingController _guestsController = TextEditingController();
  final TextEditingController _preferredDateController =
      TextEditingController();
  final TextEditingController _alternateDateController =
      TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _customOccasionController =
      TextEditingController();

  String? _selectedOccasion;
  bool _showCustomOccasionField = false;

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

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
  ) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
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
          "Event Details",
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
              ? Center(child: CircularProgressIndicator(color: Colors.white))
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomProgressBar(progress: 0.3),
                      SizedBox(height: padding * 2),
                      _buildDropdown(),
                      if (_showCustomOccasionField)
                        SizedBox(height: padding * 1.5),
                      if (_showCustomOccasionField)
                        _buildTextField(
                          "Custom Occasion",
                          _customOccasionController,
                          TextInputType.text,
                        ),
                      SizedBox(height: padding * 1.5),
                      _buildTextField(
                        "Number of Guests",
                        _guestsController,
                        TextInputType.number,
                      ),
                      SizedBox(height: padding * 1.5),
                      _buildDateField(
                        "Preferred Date",
                        _preferredDateController,
                      ),
                      SizedBox(height: padding * 1.5),
                      _buildDateField(
                        "Alternate Date",
                        _alternateDateController,
                      ),
                      SizedBox(height: padding * 1.5),
                      _buildTimeField("Start Time", _startTimeController),
                      SizedBox(height: padding * 1.5),
                      _buildTimeField("End Time", _endTimeController),
                      SizedBox(height: size.height * 0.05),
                    ],
                  ),
                ),
              ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(padding),
        child: CustomButton(buttonText: "Next", onTap: widget.goToNext),
      ),
    );
  }

  Widget _buildDropdown() {
    if (_questions.isEmpty) {
      return SizedBox();
    }

    var occasionQuestion = _questions.firstWhere(
      (q) => q['question_text'] == 'Occasion',
      orElse: () => {},
    );

    if (occasionQuestion.isEmpty) {
      return SizedBox();
    }

    List<Map<String, dynamic>> occasionOptions =
        _options[occasionQuestion['id'].toString()] ?? [];

    return DropdownButtonFormField<String>(
      dropdownColor: Colors.black,
      value: _selectedOccasion,
      style: GoogleFonts.urbanist(color: Colors.white),
      decoration: InputDecoration(
        labelText: "Occasion",
        labelStyle: GoogleFonts.urbanist(color: Colors.white70),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items:
          occasionOptions.isNotEmpty
              ? occasionOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option['option_text'] as String,
                  child: Text(
                    option['option_text'] as String,
                    style: GoogleFonts.urbanist(color: Colors.white),
                  ),
                );
              }).toList()
              : [], // Ensures an empty dropdown doesn't break the UI
      onChanged: (value) {
        setState(() {
          _selectedOccasion = value;
          _showCustomOccasionField = value == "Other";
        });
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
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context, controller),
      style: GoogleFonts.urbanist(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.urbanist(color: Colors.white70),
        suffixIcon: Icon(Icons.calendar_today, color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildTimeField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectTime(context, controller),
      style: GoogleFonts.urbanist(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.urbanist(color: Colors.white70),
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
