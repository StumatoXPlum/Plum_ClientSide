import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/custom_widgets/custom_button.dart';
import '../widgets/progress_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BudgetScreen extends StatefulWidget {
  final VoidCallback goToNext;
  final VoidCallback goToPrevious;
  final ValueChanged<double> onBudgetAmountChanged;
  const BudgetScreen({
    super.key,
    required this.goToNext,
    required this.goToPrevious,
    required this.onBudgetAmountChanged,
  });

  @override
  BudgetScreenState createState() => BudgetScreenState();
}

class BudgetScreenState extends State<BudgetScreen> {
  double _selectedBudget = 50000;
  String budgetQuestion = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchBudgetQuestion();
  }

  Future<void> fetchBudgetQuestion() async {
    final response =
        await Supabase.instance.client
            .from('questions')
            .select('question_text')
            .eq('screen_name', 'budget_screen')
            .single();

    if (mounted) {
      setState(() {
        budgetQuestion = response['question_text'];
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
          "Budget",
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomProgressBar(progress: 0.9),
            SizedBox(height: padding * 2),
            Text(
              budgetQuestion,
              style: GoogleFonts.urbanist(
                color: Colors.white,
                fontSize: fontSize * 0.9,
              ),
            ),
            SizedBox(height: padding * 2),
            Text(
              "AED ${_selectedBudget.toInt()}",
              style: GoogleFonts.urbanist(
                color: Colors.blueAccent,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              value: _selectedBudget,
              min: 1000,
              max: 100000,
              divisions: 99,
              activeColor: Colors.blueAccent,
              inactiveColor: Colors.white54,
              label: "AED ${_selectedBudget.toInt()}",
              onChanged: (double value) {
                setState(() {
                  _selectedBudget = value;
                });
                widget.onBudgetAmountChanged(value);
              },
            ),
            SizedBox(height: size.height * 0.05),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(padding),
        child: CustomButton(
          buttonText: "Next",
          onTap: () {
            widget.onBudgetAmountChanged(_selectedBudget);
            widget.goToNext();
          },
        ),
      ),
    );
  }
}
