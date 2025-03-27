import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task2/presentation/questions_screens/widgets/shimmer_widget.dart';
import '../../../core/custom_widgets/custom_button.dart';
import '../supabase/questions_service.dart';
import '../widgets/progress_bar.dart';

class EventDetails extends StatefulWidget {
  final VoidCallback goToNext;
  final VoidCallback goToPrevious;
  final ValueChanged<String> onOccasionChanged;
  final ValueChanged<String> onGuestsChanged;
  final ValueChanged<String> onPreferredDateChanged;
  final ValueChanged<String> onAlternateDateChanged;
  final ValueChanged<String> onStartTimeChanged;
  final ValueChanged<String> onEndTimeChanged;
  final ValueChanged<String> onCustomOccasionChanged;

  const EventDetails({
    super.key,
    required this.goToNext,
    required this.goToPrevious,
    required this.onOccasionChanged,
    required this.onGuestsChanged,
    required this.onPreferredDateChanged,
    required this.onAlternateDateChanged,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
    required this.onCustomOccasionChanged,
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
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Color(0xFF3579DD),
            hintColor: Colors.white,
            colorScheme: ColorScheme.dark(
              primary: Color(0xFF3579DD),
              onPrimary: Colors.white,
              surface: const Color(0xff161C25),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String formattedDate =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      setState(() {
        controller.text = formattedDate;
        if (controller == _preferredDateController) {
          widget.onPreferredDateChanged(formattedDate);
        } else if (controller == _alternateDateController) {
          widget.onAlternateDateChanged(formattedDate);
        }
      });
    } else {
      print("No date selected");
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
    ValueChanged<String?> onTimeChanged,
  ) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Color(0xFF3579DD),
            hintColor: Colors.white,
            colorScheme: ColorScheme.dark(
              primary: Color(0xFF3579DD),
              onPrimary: Colors.white,
              surface: const Color(0xff161C25),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String formattedTime =
          "${picked.hour.toString().padLeft(2, '0')}:"
          "${picked.minute.toString().padLeft(2, '0')}:00";

      setState(() {
        controller.text = picked.format(context);
        onTimeChanged(formattedTime);
      });
    } else {
      String defaultTime = "00:00:00";
      setState(() {
        controller.text = TimeOfDay(hour: 0, minute: 0).format(context);
        onTimeChanged(defaultTime);
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
      body: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
            child: CustomProgressBar(progress: 0.3),
          ),
          SizedBox(height: size.height * 0.04),
          Expanded(
            child:
                _isLoading
                    ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
                      child: ShimmerList(count: 6),
                    )
                    : SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: padding * 1.6,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDropdown(),
                            if (_showCustomOccasionField)
                              SizedBox(height: padding * 1.5),
                            if (_showCustomOccasionField)
                              _buildTextField(
                                "Custom Occasion",
                                _customOccasionController,
                                TextInputType.text,
                                widget.onCustomOccasionChanged,
                              ),
                            SizedBox(height: padding * 1.5),
                            _buildTextField(
                              "Number of Guests",
                              _guestsController,
                              TextInputType.number,
                              widget.onGuestsChanged,
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
                            _buildTimeField(
                              "Start Time",
                              _startTimeController,
                              (value) {
                                widget.onStartTimeChanged(value ?? "00:00:00");
                              },
                            ),
                            SizedBox(height: padding * 1.5),
                            _buildTimeField("End Time", _endTimeController, (
                              value,
                            ) {
                              widget.onEndTimeChanged(value ?? "00:00:00");
                            }),
                            SizedBox(height: size.height * 0.05),
                          ],
                        ),
                      ),
                    ),
          ),
        ],
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

    return DropdownButtonHideUnderline(
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
              borderSide: BorderSide(color: const Color(0xff202938)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF3579DD)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          items:
              occasionOptions.isNotEmpty
                  ? occasionOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option['option_text'] as String,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          option['option_text'] as String,
                          style: GoogleFonts.urbanist(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList()
                  : [],
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
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    TextInputType keyboardType,
    ValueChanged<String> onChanged,
  ) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: Colors.white,
      style: GoogleFonts.urbanist(color: Colors.white),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.urbanist(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xff161C25),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xff202938)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF3579DD)),
          borderRadius: BorderRadius.circular(10),
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
        filled: true,
        fillColor: const Color(0xff161C25),
        suffixIcon: Icon(Icons.calendar_today, color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xff202938)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF3579DD)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildTimeField(
    String label,
    TextEditingController controller,
    ValueChanged<String?> onTimeChanged,
  ) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectTime(context, controller, onTimeChanged),
      style: GoogleFonts.urbanist(color: Colors.white),

      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.urbanist(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xff161C25),
        suffixIcon: Icon(Icons.access_time, color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xff202938)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF3579DD)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
