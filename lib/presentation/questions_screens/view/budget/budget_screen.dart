import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_app_bar.dart';
import '../../custom_widgets/custom_progress_bar.dart';

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
  String budgetQuestion = "Approximate Budget Range";

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
      appBar: CustomAppBar(title: "Budget", onBack: widget.goToPrevious),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.02),
            CustomProgressBar(progress: 0.9),
            SizedBox(height: size.height * 0.04),
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
                color: Color(0xFF3579DD),
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              value: _selectedBudget,
              min: 1000,
              max: 100000,
              divisions: 99,
              activeColor: Color(0xFF3579DD),
              inactiveColor: const Color(0xff202938),
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
