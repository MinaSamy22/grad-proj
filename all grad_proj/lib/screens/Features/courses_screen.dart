import 'package:flutter/material.dart';

class CoursesScreen extends StatelessWidget {
  static const String routeName = '/CoursesScreen'; // Named route

  const CoursesScreen({Key? key}) : super(key: key); // ✅ الحل البديل

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Courses"),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: false,
            automaticallyImplyLeading: false, // Remove back arrow from the image
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/images/courses.jpg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Choose Your Field',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                ..._buildFieldButtons(context), // Pass context to the function
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFieldButtons(BuildContext context) {
    List<String> fields = [
      'Cybersecurity',
      'Networking',
      'Software Development',
      'Front End Developer',
      'Back End Developer',
      'Full Stack Developer',
      'Mobile Application Development',
      'Operating Systems',
      'UI/UX Design',
      'Cloud Computing',
      'Databases',
      'Database Administrator',
      'Data Science and Analytics',
      'C programming language',
      'C++ programming language',
      'C# programming language',
      'Information Technology',
      'Software Engineering',
      'Project Management',
    ];
    return fields.map((field) => FieldButton(text: field, context: context)).toList();
  }
}

class FieldButton extends StatelessWidget {
  final String text;
  final BuildContext context;

  FieldButton({required this.text, required this.context});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextButton(
          onPressed: () {
            if (text == 'Cybersecurity') {
              // Navigate to CybersecurityScreen
              Navigator.pushNamed(context, '/CybersecurityScreen');
            } else {
              print('Button pressed: $text');
            }
          },
          child: Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}