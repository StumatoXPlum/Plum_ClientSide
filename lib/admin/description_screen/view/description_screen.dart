import '../cubit/description_cubit.dart';
import '../../view_report/view/view_report_screen.dart';
import '../../../core/custom_widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DescriptionScreen extends StatefulWidget {
  const DescriptionScreen({super.key});

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descriptionController.text = context.read<DescriptionCubit>().state;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;

    return Scaffold(
      backgroundColor: const Color(0xff1F265E),
      appBar: AppBar(
        backgroundColor: const Color(0xff1F265E),
        foregroundColor: Colors.white,
        title: Text(
          "Description",
          style: GoogleFonts.poppins(fontSize: fontSize * 1.5),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _descriptionController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          cursorColor: const Color(0xff8E97FD),
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: "Description",
            labelStyle: GoogleFonts.poppins(color: Colors.white54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white70, width: 0.8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white70, width: 0.8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xff8E97FD), width: 1),
            ),
            filled: true,
            fillColor: Colors.white10,
          ),
          onChanged: (value) {
            context.read<DescriptionCubit>().updateDescription(value);
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(padding),
        child: ButtonWidget(
          buttonText: "View Report",
          onTap: () {
            if (_descriptionController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Please fill the description.",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.red.shade600,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else {
              context.read<DescriptionCubit>().updateDescription(
                _descriptionController.text,
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewReportScreen()),
              );
            }
          },
        ),
      ),
    );
  }
}
