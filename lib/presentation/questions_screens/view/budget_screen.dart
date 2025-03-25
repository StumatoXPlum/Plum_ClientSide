import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task2/core/custom_widgets/custom_button.dart';
import 'package:task2/presentation/questions_screens/widgets/progress_bar.dart';

class BudgetScreen extends StatefulWidget {
  final VoidCallback goToNext;
  final VoidCallback goToPrevious;
  const BudgetScreen({
    super.key,
    required this.goToNext,
    required this.goToPrevious,
  });

  @override
  BudgetScreenState createState() => BudgetScreenState();
}

class BudgetScreenState extends State<BudgetScreen> {
  double _selectedBudget = 50000;

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
              "Approximate Budget Range",
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
              },
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
}
