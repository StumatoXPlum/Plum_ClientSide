import 'package:flutter/material.dart';
import '../../../../../core/custom_widgets/custom_button.dart';
import '../../../custom_widgets/custom_app_bar.dart';
import '../../../custom_widgets/custom_progress_bar.dart';
import '../../../custom_widgets/custom_shimmer_widget.dart';
import '../../../custom_widgets/custom_text_field.dart';
import '../../../supabase/questions_service.dart';
import '../widgets/custom_date_widget.dart';
import '../widgets/custom_drop_down.dart';
import '../widgets/custom_time_widget.dart';

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

  void _validateAndProceed() {
    if (_guestsController.text.isEmpty ||
        _preferredDateController.text.isEmpty ||
        _startTimeController.text.isEmpty ||
        _endTimeController.text.isEmpty ||
        (_showCustomOccasionField && _customOccasionController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields", style: TextStyle()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    widget.goToNext();
  }

  @override
  void dispose() {
    _guestsController.dispose();
    _preferredDateController.dispose();
    _alternateDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _customOccasionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;

    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      appBar: CustomAppBar(title: "Event Details", onBack: widget.goToPrevious),
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
                            CustomDropdown(
                              questions: _questions,
                              options: _options,
                              onOccasionChanged: (value) {
                                setState(() {
                                  _selectedOccasion = value;
                                  _showCustomOccasionField =
                                      _selectedOccasion == "Other";
                                });
                              },
                            ),
                            if (_showCustomOccasionField)
                              SizedBox(height: padding * 1.5),
                            if (_showCustomOccasionField)
                              CustomTextField(
                                label: "Custom Occasion",
                                controller: _customOccasionController,
                                keyboardType: TextInputType.text,
                                onChanged: widget.onCustomOccasionChanged,
                              ),
                            SizedBox(height: padding * 1.5),
                            CustomTextField(
                              label: "Number of Guests",
                              controller: _guestsController,
                              keyboardType: TextInputType.number,
                              onChanged: widget.onGuestsChanged,
                            ),
                            SizedBox(height: padding * 1.5),
                            CustomDateField(
                              label: "Preferred Date",
                              controller: _preferredDateController,
                              onDateChanged: widget.onPreferredDateChanged,
                            ),
                            SizedBox(height: padding * 1.5),
                            CustomTextField(
                              label: "Alternate Date",
                              controller: _alternateDateController,
                              keyboardType: TextInputType.datetime,
                              onChanged: widget.onAlternateDateChanged,
                            ),
                            SizedBox(height: padding * 1.5),
                            CustomTimeField(
                              label: "Start Time",
                              controller: _startTimeController,
                              onTimeChanged: (value) {
                                widget.onStartTimeChanged(value ?? "00:00:00");
                              },
                            ),
                            SizedBox(height: padding * 1.5),
                            CustomTimeField(
                              label: "End Time",
                              controller: _endTimeController,
                              onTimeChanged: (value) {
                                widget.onEndTimeChanged(value ?? "00:00:00");
                              },
                            ),
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
        child: CustomButton(buttonText: "Next", onTap: _validateAndProceed),
      ),
    );
  }
}
