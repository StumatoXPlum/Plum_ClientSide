import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Color(0xff8E97FD),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.arrow_back_ios, color: Colors.white, size: fontSize),
      ),
    );
  }
}
