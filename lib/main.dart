import 'package:flutter/material.dart';
import 'package:vids_com/routes.dart';
import 'package:vids_com/screens.dart/all_news_screen.dart';
import 'package:vids_com/screens.dart/login_screen.dart';
import 'package:vids_com/screens.dart/otp_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens.dart/news_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: LoginScreen(),
      home: AllNewsScreen(),
      // home: OTPScreen(),
      routes: routes,
    );
  }
}
