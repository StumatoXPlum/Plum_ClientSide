import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/custom_widgets/custom_button.dart';
import '../widgets/progress_bar.dart';

class AdditionalRequirements extends StatefulWidget {
  final VoidCallback goToPrevious;
  const AdditionalRequirements({super.key, required this.goToPrevious});

  @override
  AdditionalRequirementsState createState() => AdditionalRequirementsState();
}

class AdditionalRequirementsState extends State<AdditionalRequirements> {
  final TextEditingController _requirementsController = TextEditingController();
  String questionText = "Loading...";

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
              CustomProgressBar(progress: 1.0),
              SizedBox(height: padding * 2),
              TextField(
                controller: _requirementsController,
                maxLines: 5,
                style: GoogleFonts.urbanist(color: Colors.white),
                decoration: InputDecoration(
                  labelText: questionText,
                  labelStyle: GoogleFonts.urbanist(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(padding),
        child: CustomButton(buttonText: "Submit", onTap: () {}),
      ),
    );
  }
}
