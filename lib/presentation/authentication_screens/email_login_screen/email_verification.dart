import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task2/presentation/authentication_screens/phone_number/phone_number.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final TextEditingController otpController = TextEditingController();
  bool isOtpEntered = false;

  @override
  void initState() {
    super.initState();
    otpController.addListener(() {
      setState(() {
        isOtpEntered = otpController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double iconSize = size.width * 0.05;
    double fontSize = size.width * 0.05;
    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      appBar: AppBar(
        backgroundColor: const Color(0xff090D14),
        leading: Padding(
          padding: EdgeInsets.only(left: padding * 1.5),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset(
              "assets/sign_up_assets/back.svg",
              height: iconSize,
              width: iconSize,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.1),
              Text(
                "Please check your email",
                style: TextStyle(
                  fontSize: fontSize * 1.6,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Switzer',
                  color: Colors.white,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                "We've sent a code to arf@gmail.com",
                style: TextStyle(
                  fontSize: fontSize * 1,
                  color: Colors.white70,
                  fontFamily: 'Switzer',
                ),
              ),

              SizedBox(height: size.height * 0.1),
              PinCodeTextField(
                cursorColor: Colors.white,
                appContext: context,
                length: 6,
                keyboardType: TextInputType.number,
                controller: otpController,
                autoFocus: true,
                textStyle: TextStyle(fontSize: 18, color: Colors.white),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12.0),
                  fieldHeight: 60,
                  fieldWidth: 50,
                  activeFillColor: Color(0xff090D14),
                  selectedFillColor: Color(0xff090D14),
                  inactiveFillColor: Color(0xff090D14),
                  activeColor: Color(0xff3579DD),
                  selectedColor: Color(0xff3579DD),
                  inactiveColor: Color(0xff3579DD),
                ),
                onChanged: (value) {},
                enableActiveFill: true,
              ),
              SizedBox(height: size.height * 0.05),
              Align(
                alignment: Alignment.center,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "I didn't receive the code ",
                        style: TextStyle(
                          fontSize: fontSize * 0.8,
                          color: Colors.white70,
                          fontFamily: 'Switzer',
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Resend",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize * 0.8,
                              fontFamily: 'Switzer',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.04),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PhoneNumber(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isOtpEntered ? Color(0xff3579DD) : Color(0xff4D4D4D),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding,
                      vertical: padding * 1.5,
                    ),
                    child: Text(
                      "Verify",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Switzer',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
