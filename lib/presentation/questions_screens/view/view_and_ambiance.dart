import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task2/core/custom_widgets/custom_button.dart';
import 'package:task2/presentation/questions_screens/widgets/progress_bar.dart';

class ViewAndAmbiance extends StatefulWidget {
  final VoidCallback goToNext;
  final VoidCallback goToPrevious;
  const ViewAndAmbiance({
    super.key,
    required this.goToNext,
    required this.goToPrevious,
  });

  @override
  ViewAndAmbianceState createState() => ViewAndAmbianceState();
}

class ViewAndAmbianceState extends State<ViewAndAmbiance> {
  String? _selectedVibe;
  final TextEditingController _descriptionController = TextEditingController();

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomProgressBar(progress: 0.5),
              SizedBox(height: padding * 2),
              _buildDropdown(),
              SizedBox(height: padding * 1.5),
              _buildTextField(
                "Would you like to describe more?",
                _descriptionController,
              ),
              SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(padding),
        child: CustomButton(buttonText: "Next", onTap: widget.goToNext),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.black,
      value: _selectedVibe,
      style: GoogleFonts.urbanist(color: Colors.white),
      decoration: InputDecoration(
        labelText: "Vibe of your event",
        labelStyle: GoogleFonts.urbanist(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      items:
          ["Casual", "Luxury", "Romantic"]
              .map(
                (label) => DropdownMenuItem(
                  value: label,
                  child: Text(
                    label,
                    style: GoogleFonts.urbanist(color: Colors.white),
                  ),
                ),
              )
              .toList(),
      onChanged: (value) {
        setState(() {
          _selectedVibe = value;
        });
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      cursorColor: Colors.white,
      controller: controller,
      style: GoogleFonts.urbanist(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.urbanist(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
