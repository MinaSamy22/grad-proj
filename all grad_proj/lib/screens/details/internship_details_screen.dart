import 'package:flutter/material.dart';

class InternshipDetailsScreen extends StatelessWidget {
  const InternshipDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.03), // Reduced padding
        child: Container(
          padding: EdgeInsets.all(11), // Reduced padding inside container
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 1.5), // Blue border frame
            borderRadius: BorderRadius.circular(8),
            color: Colors.white, // Ensuring inside remains white
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔶 JUMIA Logo + Job Title
              Container(
                padding: EdgeInsets.all(7), // Reduced padding
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company Logo & Title
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20), // Reduced padding
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "JUMIA",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.05, // Reduced font size
                            ),
                          ),
                        ),
                        SizedBox(width: 8), // Reduced spacing
                        Expanded(
                          child: Text(
                            "Internship Program - Java Developer\nJumia (Full Time)",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04, // Reduced font size
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3), // Reduced spacing

                    // Location & Date
                    Text(
                      "Cairo, Egypt • 1 month ago • 100+ applied",
                      style: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.03), // Smaller text
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.010), // Reduced spacing

              // 📌 Job Responsibilities
              _buildSectionTitle("What you will be doing:"),
              _buildBulletPoint("Assist in Java application development."),
              _buildBulletPoint("Collaborate with the team on software solutions."),
              _buildBulletPoint("Participate in code reviews."),
              _buildBulletPoint("Debug and resolve issues."),
              _buildBulletPoint("Write clean, efficient code."),
              _buildBulletPoint("Stay updated with Java trends."),
              SizedBox(height: screenHeight * 0.015), // Reduced spacing

              // 🔍 What We Are Looking For
              _buildSectionTitle("What we are looking for:"),
              _buildBulletPoint("Pursuing a Computer Science or IT degree."),
              _buildBulletPoint("Basic knowledge of Java & OOP."),
              _buildBulletPoint("Familiarity with Java frameworks is a plus."),
              _buildBulletPoint("Strong problem-solving skills."),
              _buildBulletPoint("Ability to work independently & in teams."),
              _buildBulletPoint("Good communication & willingness to learn."),
              SizedBox(height: screenHeight * 0.015), // Reduced spacing

              // 🎓 Preferred Qualifications
              _buildSectionTitle("Preferred Qualifications:"),
              _buildBulletPoint("Experience with Git."),
              _buildBulletPoint("Knowledge of web technologies & SQL."),
              _buildBulletPoint("Previous Java development projects."),
              SizedBox(height: screenHeight * 0.015), // Reduced spacing

              // Apply Now Button
              Center(
                child: SizedBox(
                  width: screenWidth * 0.55, // Smaller button width
                  height: screenHeight * 0.05, // Reduced button height
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF196AB3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Apply Now",
                      style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04), // Smaller font size
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01), // Reduced spacing
            ],
          ),
        ),
      ),
    );
  }

  // 📌 Helper Methods for Titles & Bullet Points
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4), // Reduced spacing
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16, // Smaller font
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2), // Reduced spacing
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), // Smaller bullet size
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14), // Smaller text size
            ),
          ),
        ],
      ),
    );
  }
}
