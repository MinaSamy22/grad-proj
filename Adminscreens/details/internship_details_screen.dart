import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Student Screens/Features/Apply Process/CV_Options_Screen.dart';

class InternshipDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> internshipData;

  const InternshipDetailsScreen({Key? key, required this.internshipData}) : super(key: key);

  Future<void> _checkAndProceed(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You must be logged in to apply.")),
        );
        return;
      }

      var existingApplication = await FirebaseFirestore.instance
          .collection('applications')
          .where('userId', isEqualTo: user.uid)
          .where('internshipId', isEqualTo: internshipData["internshipId"])
          .get();

      if (existingApplication.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You have already applied for this internship.")),
        );
        return;
      }

      // If all checks pass, navigate to the CVOptionScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CVOptionScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to proceed. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Container(
          padding: EdgeInsets.all(11),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 1.5),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔶 Company Info
              Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            internshipData["company"] ?? "Unknown Company",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.05,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            internshipData["title"] ?? "Unknown Title",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Text(
                      internshipData["location"] ?? "Unknown Location",
                      style: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.03),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.010),

              _buildSectionTitle("What you will be doing:"),
              ..._buildDynamicBulletPoints(
                internshipData["whatYouWillBeDoing"] is List
                    ? internshipData["whatYouWillBeDoing"]
                    : (internshipData["whatYouWillBeDoing"] as String?)?.split("-") ?? [],
              ),

              _buildSectionTitle("What we are looking for:"),
              ..._buildDynamicBulletPoints(
                internshipData["whatWeAreLookingFor"] is List
                    ? internshipData["whatWeAreLookingFor"]
                    : (internshipData["whatWeAreLookingFor"] as String?)?.split("-") ?? [],
              ),

              _buildSectionTitle("Preferred Qualifications:"),
              ..._buildDynamicBulletPoints(
                internshipData["preferredQualifications"] is List
                    ? internshipData["preferredQualifications"]
                    : (internshipData["preferredQualifications"] as String?)?.split("-") ?? [],
              ),

              // 📩 Apply Button
              Center(
                child: SizedBox(
                  width: screenWidth * 0.55,
                  height: screenHeight * 0.05,

                  ),
                ),

              SizedBox(height: screenHeight * 0.01),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text.trim(),
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDynamicBulletPoints(List<dynamic>? items) {
    if (items == null || items.isEmpty) {
      return [_buildBulletPoint("No information available.")];
    }
    return items.map((item) => _buildBulletPoint(item.toString())).toList();
  }
}
