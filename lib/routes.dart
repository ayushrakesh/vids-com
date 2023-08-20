import 'package:flutter/material.dart';
import 'package:vids_com/screens/all_news_screen.dart';
import 'package:vids_com/screens/news_details.dart';
import 'package:vids_com/screens/otp_screen.dart';
import 'package:vids_com/screens/video_post_screen.dart';

final Map<String, WidgetBuilder> routes = {
  OTPScreen.routename: (context) => OTPScreen(),
  NewsDetails.routeName: (context) => NewsDetails(),
  AllNewsScreen.routeName: (context) => AllNewsScreen(),
  VideoPostScreen.routeName: (context) => VideoPostScreen()
};
