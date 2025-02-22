import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/ProfileScreen'; // Named route

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Welcome fl profileeee', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
