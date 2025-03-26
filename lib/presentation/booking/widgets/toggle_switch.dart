import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToggleSwitch extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onToggle;

  const ToggleSwitch({
    super.key,
    required this.selectedIndex,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double toggleWidth = size.width * 0.45;
    double toggleHeight = size.height * 0.06;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      child: Container(
        height: toggleHeight,
        width: size.width * 0.9,
        decoration: BoxDecoration(
          color: const Color(0xff1B1E27),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: selectedIndex * toggleWidth,
              child: Container(
                width: toggleWidth,
                height: toggleHeight,
                decoration: BoxDecoration(
                  color: const Color(0xff3579DD),
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
            Row(
              children: [
                _buildToggleOption("Your Bookings", 0, toggleWidth),
                _buildToggleOption("Group Bookings", 1, toggleWidth),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOption(String text, int index, double width) {
    return GestureDetector(
      onTap: () => onToggle(index),
      child: SizedBox(
        width: width,
        height: double.infinity,
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: selectedIndex == index ? Colors.white : Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }
}
