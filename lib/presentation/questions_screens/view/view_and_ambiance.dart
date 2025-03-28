import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task2/core/custom_widgets/custom_button.dart';
import 'package:task2/presentation/questions_screens/widgets/custom_text_field.dart';
import 'package:task2/presentation/questions_screens/widgets/progress_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task2/presentation/questions_screens/widgets/shimmer_widget.dart';

class ViewAndAmbiance extends StatefulWidget {
  final VoidCallback goToNext;
  final VoidCallback goToPrevious;
  final ValueChanged<String?> onVibeOfEventChanged;
  final ValueChanged<String?> onEventDescriptionChanged;

  const ViewAndAmbiance({
    super.key,
    required this.goToNext,
    required this.goToPrevious,
    required this.onVibeOfEventChanged,
    required this.onEventDescriptionChanged,
  });

  @override
  ViewAndAmbianceState createState() => ViewAndAmbianceState();
}

class ViewAndAmbianceState extends State<ViewAndAmbiance> {
  String? _selectedVibe;
  final TextEditingController _descriptionController = TextEditingController();

  List<String> vibeOptions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('questions')
          .select('id, question_text, input_type, options(option_text)')
          .eq('screen_name', 'view_and_ambiance');

      if (response.isNotEmpty) {
        for (var question in response) {
          if (question['question_text'] == 'Vibe of your event') {
            setState(() {
              vibeOptions =
                  (question['options'] as List)
                      .map((option) => option['option_text'] as String)
                      .toList();
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching questions: $e');
    } finally {
      setState(() {
        isLoading = false;
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
          "View and Ambiance",
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
            child: CustomProgressBar(progress: 0.7),
          ),
          SizedBox(height: size.height * 0.04),
          Expanded(
            child:
                isLoading
                    ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
                      child: ShimmerList(count: 2),
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
                            SizedBox(height: padding * 1.5),
                            CustomTextField(
                              label: "Would you like to describe more?",
                              controller: _descriptionController,
                              keyboardType: TextInputType.text,
                              onChanged: widget.onEventDescriptionChanged,
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
        child: CustomButton(buttonText: "Next", onTap: widget.goToNext),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<String>(
          dropdownColor: const Color(0xff161C25),
          value: _selectedVibe,
          style: GoogleFonts.urbanist(color: Colors.white),
          decoration: InputDecoration(
            labelText: "Vibe of your event",
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
              vibeOptions
                  .map(
                    (label) => DropdownMenuItem(
                      value: label,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 200),

                        child: Text(
                          label,
                          style: GoogleFonts.urbanist(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() {
              _selectedVibe = value;
            });
            widget.onVibeOfEventChanged(value);
          },
          alignment: Alignment.centerLeft,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
