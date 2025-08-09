import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const YogaApp());
}

class YogaApp extends StatelessWidget {
  const YogaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modular Yoga App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(), 
    );
  }
}
