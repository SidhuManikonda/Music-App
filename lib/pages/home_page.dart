import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myportifolio/app_controller.dart';
import 'package:myportifolio/widgets/custom_button.dart';
import 'package:myportifolio/widgets/custom_field_widget.dart';
import 'package:myportifolio/widgets/custom_text_field.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String _verificationId = '';
  void verifyMobileNumber() async {
    final authService = ref.read(AppControllers.authController);
    String mobileNumber=mobileNumberController.text.trim();
    if(mobileNumber.isEmpty){
       print("Please enter a valid mobile number");
       return;
    }
    await authService.verifyMobileNumber(mobileNumber,
        (verificationId) {
      setState(() {
        _verificationId = verificationId;
      });
      showOtpDialouge();
    });
  }

  void showOtpDialouge() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter OTP"),
            content: TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final authService = ref.read(AppControllers.authController);
                  await authService.signInWithOtp(
                      _verificationId, otpController.text.trim());
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome Back',
                style: TextStyle(
                    fontSize: 24, height: 1.4, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Enter your mobile number to send otp',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Color(0xFF474747)
                          // ignore: deprecated_member_use
                          : Color(0xFFFFFFFF).withOpacity(0.72)),
                ),
              ),
              SizedBox(height: 32),
              CustomFieldWidget(
                fieldTitle: "Mobile Number",
                child: CustomTextField(controller: mobileNumberController),
              ),
              SizedBox(height: 32),
              CustomButton(
                text: "Submit",
                onTap:verifyMobileNumber,
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
