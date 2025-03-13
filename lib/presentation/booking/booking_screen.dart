import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      body: Center(
        child: Text("booking screen", style: TextStyle(color: Colors.white)),
      ),
    );
  }  
}
