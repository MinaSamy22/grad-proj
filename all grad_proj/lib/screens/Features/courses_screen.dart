import 'package:flutter/material.dart';

class CoursesScreen extends StatelessWidget {
  static const String routeName = '/CoursesScreen'; // Named route

  const CoursesScreen({Key? key}) : super(key: key); // ✅ الحل البديل
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Welcome heree course yla ', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
