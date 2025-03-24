import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task2/core/custom_widgets/custom_button.dart';
import 'package:task2/presentation/questions_screens/view/booking_preference.dart';
import 'package:task2/presentation/questions_screens/widgets/progress_bar.dart';

class GroupSizeScreen extends StatefulWidget {
  const GroupSizeScreen({super.key});

  @override
  GroupSizeScreenState createState() => GroupSizeScreenState();
}

class GroupSizeScreenState extends State<GroupSizeScreen> {
  final TextEditingController _totalMembersController = TextEditingController();
  final TextEditingController _infantsController = TextEditingController();
  final TextEditingController _childrenController = TextEditingController();
  final TextEditingController _adultsController = TextEditingController();
  final TextEditingController _seniorsController = TextEditingController();

  Future<void> _storeGroupSizeResponse() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      return;
    }

    try {
      final questionData =
          await supabase
              .from('questions')
              .select('id')
              .eq('question', 'Enter Group Size')
              .maybeSingle();

      if (questionData == null) {
        return;
      }

      final questionId = questionData['id'];

      final response = await supabase.from('responses').insert([
        {
          'user_id': user.id,
          'question_id': questionId,
          'response': {
            'total_members': int.tryParse(_totalMembersController.text) ?? 0,
            'infants': int.tryParse(_infantsController.text) ?? 0,
            'children': int.tryParse(_childrenController.text) ?? 0,
            'adults': int.tryParse(_adultsController.text) ?? 0,
            'seniors': int.tryParse(_seniorsController.text) ?? 0,
          },
        },
      ]);

      if (response.error != null) {
      } else {
        print('Group size response stored successfully!');
      }
    } catch (error) {
      print('Error storing response: $error');
    }
  }

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
          "Group Preference",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
          child: Column(
            children: [
              CustomProgressBar(progress: 0.2),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.02),
                      Text(
                        "Enter Group Size",
                        style: GoogleFonts.urbanist(
                          fontSize: fontSize * 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      _buildNumberInput(
                        "Total Members",
                        _totalMembersController,
                      ),
                      _buildNumberInput("Infants", _infantsController),
                      _buildNumberInput("Children", _childrenController),
                      _buildNumberInput("Adults", _adultsController),
                      _buildNumberInput("Seniors", _seniorsController),
                      SizedBox(height: size.height * 0.02),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: padding * 1.5),
                child: CustomButton(
                  buttonText: "Next",
                  onTap: () async {
                    await _storeGroupSizeResponse();
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const BookingPreferenceScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        cursorColor: Colors.white,
        style: GoogleFonts.urbanist(color: Colors.white),
        controller: controller,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.urbanist(color: Colors.white70),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xff3579DD)),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _totalMembersController.dispose();
    _infantsController.dispose();
    _childrenController.dispose();
    _adultsController.dispose();
    _seniorsController.dispose();
    super.dispose();
  }
}
