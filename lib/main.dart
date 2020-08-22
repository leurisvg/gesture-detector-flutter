import 'package:flutter/material.dart';

import 'package:gesture_detector/src/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gesture Detector',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
