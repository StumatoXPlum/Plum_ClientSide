import '../../description_screen/view/description_screen.dart';
import '../cubit/report_details_cubit.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/custom_time_picker.dart';
import '../../../core/custom_widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportDetailsScreen extends StatefulWidget {
  const ReportDetailsScreen({super.key});

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ReportDetailsCubit>();
    _titleController.text = cubit.state.title;
    _subtitleController.text = cubit.state.subtitle;
    _dateController.text = cubit.state.date;
    _timeController.text = cubit.state.time;
  }

  void _validateAndProceed() {
    if (_titleController.text.isEmpty ||
        _subtitleController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please fill all required fields.",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final cubit = context.read<ReportDetailsCubit>();
    cubit.updateTitle(_titleController.text);
    cubit.updateSubtitle(_subtitleController.text);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DescriptionScreen()),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
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
          "Report Details",
          style: GoogleFonts.poppins(fontSize: fontSize * 1.5),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: padding,
          vertical: padding * 2,
        ),
        child: Column(
          spacing: size.height * 0.03,
          children: [
            _buildTextField("Title", _titleController, null, () {}),
            _buildTextField("Subtitle", _subtitleController, null, () {}),
            CustomDateField(
              label: "Date",
              controller: _dateController,
              onDateChanged: (formattedDate) {
                _dateController.text = formattedDate;
                context.read<ReportDetailsCubit>().updateDate(formattedDate);
              },
            ),

            CustomTimeField(
              label: "Time",
              controller: _timeController,
              onTimeChanged: (formattedTime) {
                _timeController.text = formattedTime;
                context.read<ReportDetailsCubit>().updateTime(formattedTime);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(padding),
        child: ButtonWidget(buttonText: "Next", onTap: _validateAndProceed),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData? icon,
    VoidCallback? onTap,
  ) {
    final cubit = context.read<ReportDetailsCubit>();
    final Size size = MediaQuery.of(context).size;
    double fontSize = size.width * 0.045;
    bool isDateOrTime = label == "Date" || label == "Time";

    return TextFormField(
      controller: controller,
      cursorColor: const Color(0xff8E97FD),
      readOnly: isDateOrTime,
      onTap: isDateOrTime ? onTap : null,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: fontSize),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        label: Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: fontSize * 0.9,
          ),
        ),
        filled: true,
        fillColor: Colors.white10,
        suffixIcon:
            icon != null ? Icon(icon, color: const Color(0xff8E97FD)) : null,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70, width: 0.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70, width: 0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xff8E97FD), width: 0.8),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: (value) {
        if (label == "Title") {
          cubit.updateTitle(value);
        } else if (label == "Subtitle") {
          cubit.updateSubtitle(value);
        }
      },
    );
  }
}
