import 'package:flutter/material.dart';
import 'package:vids_com/screens.dart/news_details.dart';
import 'package:vids_com/screens.dart/otp_screen.dart';

final Map<String, WidgetBuilder> routes = {
  OTPScreen.routename: (context) => OTPScreen(),
  NewsDetails.routeName: (context) => NewsDetails()
};
