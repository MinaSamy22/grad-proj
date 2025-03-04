import 'package:flutter/material.dart';
import '../details/internship_details_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/HomeScreen'; // Named route

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isNotified = false; // State for notification button
  bool isSaved = false; // State for Save button

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.08,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👋 Welcome Title
            Text(
              "Welcome To Your Future",
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
                height: 2,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // 🔍 Search Bar
            SizedBox(
              height: screenHeight * 0.06,
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04),
                  prefixIcon: Icon(Icons.search, color: Colors.white, size: screenWidth * 0.06),
                  filled: true,
                  fillColor: Colors.blue.shade200,
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // 📌 Job Listing Container (White Background)
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                color: Colors.white, // Fully white container
                border: Border.all(color: Colors.blue, width: 1.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job Header
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.045),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "JUMIA",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Expanded(
                        child: Text(
                          "Internship Program - Java Developer Jumia (Full Time)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ),
                      // 🛎️ Notification Button

                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  // Job Description
                  Text(
                    "Cairo, Egypt - 1 month ago • Over 100 people clicked apply",
                    style: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.033),
                  ),
                  SizedBox(height: screenHeight * 0.015),

                  // Job Tags
                  Row(
                    children: [
                      _buildTag("On-site", Icons.check),
                      SizedBox(width: screenWidth * 0.02),
                      _buildTag("Internship", Icons.check),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Action Buttons (🔘 See More & Save)
                  Row(
                    children: [
                      // See More Button
                      Expanded(
                        child: SizedBox(
                          height: screenHeight * 0.04,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => InternshipDetailsScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF196AB3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            label: Text("See More", style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04)),
                            icon: Icon(Icons.trending_up, color: Colors.white, size: screenWidth * 0.05),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),

                      // Save Button (Toggles Blue on Click)
                      Expanded(
                        child: SizedBox(
                          height: screenHeight * 0.04,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                isSaved = !isSaved;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: isSaved ? Colors.blue : Colors.white, // Toggle Blue
                              side: BorderSide(color: Colors.blue, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            icon: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: isSaved ? Colors.white : Colors.blue, // Toggle Icon Color
                              size: screenWidth * 0.05,
                            ),
                            label: Text(
                              "Save",
                              style: TextStyle(
                                color: isSaved ? Colors.white : Colors.blue, // Toggle Text Color
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Helper Method for Job Tags
  Widget _buildTag(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Text(text, style: TextStyle(color: Colors.white, fontSize: 14)),
          SizedBox(width: 5),
          Icon(icon, color: Colors.white, size: 16),
        ],
      ),
    );
  }
}
