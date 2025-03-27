import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task2/core/custom_widgets/bottom_navigation_bar.dart';
import 'package:task2/core/custom_widgets/loading_button.dart';
import 'package:task2/presentation/questions_screens/supabase/save_response_service.dart';
import '../widgets/progress_bar.dart';

class AdditionalRequirements extends StatefulWidget {
  final VoidCallback goToPrevious;
  final String? userId;
  final String fullName;
  final String contactNumber;
  final String email;
  final String occasion;
  final String numberOfGuests;
  final String preferredDate;
  final String alternateDate;
  final String startTime;
  final String endTime;
  final bool exclusiveVenue;
  final String preferredVenueType;
  final String desiredLocationOrArea;
  final String vibeOfEvent;
  final String eventDescription;
  final double budgetAmount;
  final ValueChanged<String> onAdditionalRequirementsChanged;

  const AdditionalRequirements({
    super.key,
    required this.goToPrevious,
    required this.userId,
    required this.fullName,
    required this.contactNumber,
    required this.email,
    required this.occasion,
    required this.numberOfGuests,
    required this.preferredDate,
    required this.alternateDate,
    required this.startTime,
    required this.endTime,
    required this.exclusiveVenue,
    required this.preferredVenueType,
    required this.desiredLocationOrArea,
    required this.vibeOfEvent,
    required this.eventDescription,
    required this.budgetAmount,
    required this.onAdditionalRequirementsChanged,
  });

  @override
  AdditionalRequirementsState createState() => AdditionalRequirementsState();
}

class AdditionalRequirementsState extends State<AdditionalRequirements> {
  final TextEditingController _requirementsController = TextEditingController();
  String questionText = "Do you have any additional requirements?";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchQuestion();
  }

  Future<void> fetchQuestion() async {
    final supabase = Supabase.instance.client;
    final response =
        await supabase
            .from('questions')
            .select('question_text')
            .eq('screen_name', 'additional_requirements')
            .maybeSingle();

    if (response != null) {
      setState(() {
        questionText =
            response['question_text'] ??
            "Do you have any additional requirements?";
      });
    }
  }

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final saveResponseService = SaveResponseService();
      await saveResponseService.saveResponses(
        userId: widget.userId,
        fullName: widget.fullName,
        contactNumber: widget.contactNumber,
        email: widget.email,
        occasion: widget.occasion,
        numberOfGuests: widget.numberOfGuests,
        preferredDate:
            widget.preferredDate.isEmpty ? null : widget.preferredDate,
        alternateDate:
            widget.alternateDate.isEmpty ? null : widget.alternateDate,
        startTime: widget.startTime,
        endTime: widget.endTime,
        exclusiveVenue: widget.exclusiveVenue,
        preferredVenueType: widget.preferredVenueType,
        desiredLocationOrArea: widget.desiredLocationOrArea,
        vibeOfEvent: widget.vibeOfEvent,
        eventDescription: widget.eventDescription,
        budgetAmount: widget.budgetAmount,
        additionalRequirements: _requirementsController.text,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  BottomNavScreen(initialIndex: 2, fromSubmitButton: true),
        ),
        (route) => false,
      );
    } catch (e) {
      print("Failed to save responses: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
          "Additional Requirements",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.02),
              CustomProgressBar(progress: 1.0),
              SizedBox(height: size.height * 0.04),
              TextField(
                controller: _requirementsController,
                maxLines: 5,
                cursorColor: Colors.white,
                style: GoogleFonts.urbanist(color: Colors.white),
                decoration: InputDecoration(
                  labelText: questionText,
                  labelStyle: GoogleFonts.urbanist(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white10,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF3579DD)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged:
                    (value) => widget.onAdditionalRequirementsChanged(value),
              ),
              SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(padding),
        child: LoadingButton(
          buttonText: _isLoading ? "Loading..." : "Submit",
          onTap: _isLoading ? () {} : _submitForm,
          isLoading: _isLoading,
        ),
      ),
    );
  }
}
