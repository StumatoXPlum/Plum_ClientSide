import 'package:aloha_funds/admin/image_picker/view/image_picker_screen.dart';
import 'package:aloha_funds/core/custom_widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String adminEmail = "dartsmith29@gmail.com";
  final String adminPassword = "123456";
  bool isLoading = false;
  String? errorMessage;

  Future<void> _loginAdmin() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    await Future.delayed(Duration(seconds: 1));

    if (_emailController.text == adminEmail &&
        _passwordController.text == adminPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ImagePickerScreen()),
      );
    } else {
      setState(() {
        errorMessage = "Invalid email or password";
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;
    return Scaffold(
      backgroundColor: Color(0xff1F265E),
      appBar: AppBar(
        backgroundColor: const Color(0xff1F265E),
        title: Text(
          "Admin Login",
          style: GoogleFonts.poppins(fontSize: fontSize * 1.5),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                "assets/home_assets/admin.svg",
                height: size.height * 0.3,
                width: size.width * 0.8,
              ),
              customTextField("Email", _emailController),
              SizedBox(height: size.height * 0.02),
              customTextField("Password", _passwordController),
              if (errorMessage != null)
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: size.height * 0.06),
              ButtonWidget(
                onTap: _loginAdmin,
                buttonText: "Login",
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget customTextField(String label, TextEditingController controller) {
  return TextField(
    controller: controller,
    cursorColor: Colors.white,
    style: GoogleFonts.poppins(color: Colors.white),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(color: Colors.white70),
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff8E97FD)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white70),
      ),
      filled: true,
      fillColor: Colors.white10,
    ),
  );
}
