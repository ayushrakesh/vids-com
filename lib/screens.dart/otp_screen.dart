import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../utils/app_styles.dart';

class OTPScreen extends StatefulWidget {
  static const routename = '/otp';

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final height = Get.height;
  final width = Get.width;

  String? otp;

  final otpCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final phone =
        (ModalRoute.of(context)!.settings.arguments as List)[0] as String;
    final username =
        (ModalRoute.of(context)!.settings.arguments as List)[1] as String;

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('OTP'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: height * 0.04, vertical: height * 0.04),
          child: Column(
            children: [
              Gap(height * 0.1),
              TextFormField(
                controller: otpCtl,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.length < 10) {
                    return 'Please provide a valid phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    otp = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter one time password here',
                  hintStyle:
                      TextStyle(color: Styles.primaryColor, letterSpacing: 0.7),
                  fillColor: Colors.indigo.shade100,
                  filled: true,
                  errorStyle: TextStyle(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 235, 195, 75),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: height * 0.02, horizontal: width * 0.08),
                ),
              ),
              // Gap(height * 0.01),
              Row(
                children: [
                  Text('Did not get otp? '),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Resend OTP',
                      style: TextStyle(
                        color: Colors.pink,
                      ),
                    ),
                  )
                ],
              ),
              Gap(height * 0.03),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255, 2, 9, 65),
                    Color.fromARGB(255, 14, 31, 163)
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    // backgroundColor: Color.fromARGB(255, 2, 9, 65),
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.3, vertical: height * 0.02),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      // otpCtl.clear();
                    }
                    FocusScope.of(context).unfocus();
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(color: Styles.bgColor, letterSpacing: 0.6),
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
