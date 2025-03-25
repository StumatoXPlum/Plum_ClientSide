import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task2/core/custom_widgets/custom_button.dart';
import 'package:task2/presentation/questions_screens/widgets/progress_bar.dart';

class VenuePreferences extends StatefulWidget {
  final VoidCallback goToNext;
  final VoidCallback goToPrevious;
  const VenuePreferences({
    super.key,
    required this.goToNext,
    required this.goToPrevious,
  });

  @override
  VenuePreferencesState createState() => VenuePreferencesState();
}

class VenuePreferencesState extends State<VenuePreferences> {
  final TextEditingController _locationController = TextEditingController();

  String? _exclusiveVenue;
  String? _venueType;

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
          "Venue Preferences",
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
              _buildDropdown(
                "Do you require an exclusive venue?",
                ["Yes", "No"],
                (value) {
                  setState(() {
                    _exclusiveVenue = value;
                  });
                },
                _exclusiveVenue,
              ),
              SizedBox(height: padding * 1.5),
              _buildDropdown(
                "Preferred Venue Type",
                ["Indoor", "Outdoor", "Rooftop", "Club", "Lounge"],
                (value) {
                  setState(() {
                    _venueType = value;
                  });
                },
                _venueType,
              ),
              SizedBox(height: padding * 1.5),
              _buildTextField(
                "Desired Location or Area",
                _locationController,
                TextInputType.text,
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

  Widget _buildDropdown(
    String label,
    List<String> options,
    Function(String?) onChanged,
    String? value,
  ) {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.black,
      value: value,
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
      items:
          options
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
      onChanged: onChanged,
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    TextInputType keyboardType,
  ) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: Colors.white,
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
