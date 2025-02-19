import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  static const String routeName = '/HomeScreen'; // Named route

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isNotified = false; // State for notification button

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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

            // 📌 Job Listing Card
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Job Header
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(screenWidth * 0.02),
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
                              "Internship Program - Java Developer\nJumia (Full Time)",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                          ),
                          // 🛎️ Notification Button
                          IconButton(
                            icon: Icon(
                              isNotified ? Icons.notifications_active : Icons.notifications_outlined,
                              color: isNotified ? Colors.blue : Colors.grey,
                              size: screenWidth * 0.06,
                            ),
                            onPressed: () {
                              setState(() {
                                isNotified = !isNotified;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      // Job Description
                      Text(
                        "Cairo, Egypt - 1 month ago • Over 100 people clicked apply",
                        style: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.035),
                      ),
                      SizedBox(height: screenHeight * 0.015),

                      // Job Tags
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade200, // Match search bar color
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "On-site",
                                  style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.035),
                                ),
                                SizedBox(width: 5),
                                Icon(Icons.check, color: Colors.white, size: screenWidth * 0.045),
                              ],
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade200, // Match search bar color
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Internship",
                                  style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.035),
                                ),
                                SizedBox(width: 5),
                                Icon(Icons.check, color: Colors.white, size: screenWidth * 0.045),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Action Buttons (🔘 See More & Save)
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: screenHeight * 0.04,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF196AB3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                icon: Icon(Icons.trending_up, color: Colors.white, size: screenWidth * 0.05),
                                label: Text(
                                  "See More",
                                  style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Expanded(
                            child: SizedBox(
                              height: screenHeight * 0.04,
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.blue, width: 1.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                icon: Icon(Icons.bookmark_border, color: Colors.blue, size: screenWidth * 0.05),
                                label: Text(
                                  "Save",
                                  style: TextStyle(color: Colors.blue, fontSize: screenWidth * 0.04),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
