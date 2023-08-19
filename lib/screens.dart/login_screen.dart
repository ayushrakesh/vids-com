import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../utils/app_styles.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final height = Get.height;
  final width = Get.width;

  final phoneCtl = TextEditingController();
  final smsCtl = TextEditingController();
  final usernameCtl = TextEditingController();

  String? phone;
  String? sms;
  String? username;

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  void submitForm() async {}

  void sendOtp() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: '+91 $phone',
      codeSent: (String verificationId, int? resendToken) async {
        print(verificationId);
        print(resendToken);
        // Update the UI - wait for the user to enter the SMS code
        String smsCode = 'xxxx';

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print(verificationId);
      },
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
        print(phoneAuthCredential);
      },
      verificationFailed: (FirebaseAuthException error) {
        print(error);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login'),
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
              const Text(
                'Welcome Back',
                style: TextStyle(
                    letterSpacing: 0.8,
                    color: Color.fromARGB(255, 1, 37, 66),
                    fontSize: 38,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'Login to your account',
                style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 2, 58, 104),
                    fontWeight: FontWeight.w300),
              ),
              Gap(height * 0.06),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: phoneCtl,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.length < 10) {
                          return 'Please provide a valid phone number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          phone = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Phone',
                        hintStyle: TextStyle(
                            color: Styles.primaryColor, letterSpacing: 0.7),
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
                    Gap(height * 0.03),
                    TextFormField(
                      controller: usernameCtl,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a valid username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          username = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: TextStyle(
                            color: Styles.primaryColor, letterSpacing: 0.7),
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
                    Gap(height * 0.05),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 2, 9, 65),
                              Color.fromARGB(255, 14, 31, 163)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
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

                            // phoneCtl.clear();
                            sendOtp();
                            Navigator.of(context).pushNamed(OTPScreen.routename,
                                arguments: [phone, username]);
                          }
                          FocusScope.of(context).unfocus();
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(
                              color: Styles.bgColor, letterSpacing: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
