import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_app_bar.dart';
import '../../custom_widgets/custom_progress_bar.dart';
import '../../custom_widgets/custom_shimmer_widget.dart';
import '../../custom_widgets/custom_text_field.dart';

class PersonalInfo extends StatefulWidget {
  final VoidCallback goToNext;
  final ValueChanged<String> onFullNameChanged;
  final ValueChanged<String> onContactNumberChanged;
  final ValueChanged<String> onEmailChanged;

  const PersonalInfo({
    super.key,
    required this.goToNext,
    required this.onFullNameChanged,
    required this.onContactNumberChanged,
    required this.onEmailChanged,
  });

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        final response =
            await supabase
                .from('users')
                .select('name, phonenumber, email')
                .eq('email', user.email!)
                .single();

        setState(() {
          fullNameController.text = response['name'] ?? '';
          contactNumberController.text = response['phonenumber'] ?? '';
          emailController.text = response['email'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user details: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    contactNumberController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      appBar: CustomAppBar(
        title: "Personal Information",
        onBack: Navigator.of(context).pop,
      ),
      body: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
            child: CustomProgressBar(progress: 0.15),
          ),
          SizedBox(height: size.height * 0.04),
          Expanded(
            child:
                _isLoading
                    ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
                      child: ShimmerList(count: 3),
                    )
                    : Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            label: "Full Name",
                            controller: fullNameController,
                            keyboardType: TextInputType.text,
                            onChanged: widget.onFullNameChanged,
                          ),
                          SizedBox(height: size.height * 0.02),
                          CustomTextField(
                            label: "Contact Number",
                            controller: contactNumberController,
                            keyboardType: TextInputType.phone,
                            onChanged: widget.onContactNumberChanged,
                          ),
                          SizedBox(height: size.height * 0.02),
                          CustomTextField(
                            label: "Email Address",
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: widget.onEmailChanged,
                          ),
                          SizedBox(height: size.height * 0.02),
                        ],
                      ),
                    ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(padding),
        child: CustomButton(buttonText: "Next", onTap: widget.goToNext),
      ),
    );
  }
}
