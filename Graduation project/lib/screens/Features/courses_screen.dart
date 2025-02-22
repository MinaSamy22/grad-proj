import 'package:flutter/material.dart';

class CoursesScreen extends StatelessWidget {
  static const String routeName = '/CoursesScreen'; // Named route

  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Welcome heree course yla ', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
