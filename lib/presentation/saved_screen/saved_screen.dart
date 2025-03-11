import 'package:flutter/material.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      body: Center(
        child: Text("saved screen", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
