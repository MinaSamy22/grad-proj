import 'package:flutter/material.dart';

class CybersecurityScreen extends StatelessWidget {
  static const String routeName = "CybersecurityScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView( // Make content scrollable
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Cybersecurity',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Cybersecurity is the practice of protecting internet-connected systems such as hardware, software, and data from cyber threats. ',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 140),
                Center(
                  //child: VideoPlayerWidget(),
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/arrow-right.png', // Replace with your image path
                      height: 20, // Adjust image size as needed
                    ),
                    SizedBox(width: 8), // Add space between image and text
                    Expanded(
                      child: Container(
                        child: Text(
                          'Click here to explore the Cybersecurity Roadmap',
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Center(
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to Roadmap screen or perform action
                      print('Roadmap button pressed');
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),

                      ),
                      side: BorderSide(color: Color(0xFF196AB3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Roadmap',
                          style: TextStyle(color: Color(0xFF196AB3)),
                        ),
                        SizedBox(width: 8), // Add some space between the text and image
                        Image.asset(
                          'assets/images/roadmap.png', // Replace with your image path
                          height: 26, // Adjust the image size as needed
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
                CourseCard(
                  logo: 'assets/images/udemy.png', // Replace with your logo path

                  title: 'Cybersecurity course',
                  subtitle: 'Online Courses',
                  onApply: () {
                    print('Udemy Apply button pressed');
                  },

                ),
                SizedBox(height: 16),
                CourseCard(
                  logo: 'assets/images/coursera.png',
                  title: 'Cybersecurity course',
                  subtitle: 'Online Courses',
                  onApply: () {
                    print('Coursera Apply button pressed');
                  },

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String logo;
  final String title;
  final String subtitle;
  final VoidCallback onApply;


  CourseCard({
    required this.logo,
    required this.title,
    required this.subtitle,
    required this.onApply,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF196AB3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset(
                      logo,
                      height: 50,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF196AB3), // Set button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Apply',
                        style: TextStyle(color: Colors.white, fontSize: 15), // Set text color to white
                      ),
                      SizedBox(width: 40),
                      Image.asset(
                        'assets/images/tap.png',
                        color: Colors.white,// Replace with your image path
                        height: 25, // Adjust image size as needed
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ),
        );
    }
}