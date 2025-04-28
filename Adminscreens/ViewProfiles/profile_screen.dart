import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Student Screens/Auth/login_screen.dart';
import 'student/students.dart';
import 'company/companies.dart';

class ViewProfiles extends StatelessWidget {
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // your login screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.blue),
            tooltip: "Logout",
            onPressed: () => _logout(context),
          ),
        ],
        title: Text(
          "View Profiles",
          style: TextStyle(color: Color(0xFF2252A1), fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Choose to manage",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2252A1)),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Student
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StudentsScreen()),
                    );
                  },
                  child: _buildProfileCard(icon: Icons.person, label: "Student"),
                ),

                // Company
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => companies()),
                    );
                  },
                  child: _buildProfileCard(icon: Icons.business, label: "Company"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard({required IconData icon, required String label}) {
    return Container(
      width: 140,
      height: 140,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.blue),
          SizedBox(height: 5),
          Text(label, style: TextStyle(color: Colors.blue, fontSize: 16)),
        ],
      ),
    );
  }
}
