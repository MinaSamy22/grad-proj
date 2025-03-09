import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import '../Auth/login_screen.dart';
import 'main_screen.dart'; // Import your main screen file

class ProfileScreen extends StatelessWidget {
  static const String routeName = "ProfileScreen";

  // Function to handle logout
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login screen after successful logout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out. Please try again.')),
      );
    }
  }

  // Function to show confirmation dialog before logout
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel", style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout(context); // Proceed with logout
              },
              child: Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'My Profile',
          style: TextStyle(
            color: Color(0xFF040404),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()), // Navigate to MainScreen
            );
          },
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: null,
                        child: Icon(
                          Icons.person,
                          size: 90,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20), // Add some spacing

                // Personal Information Section
                buildSectionHeader('Personal Information', context),
                buildInfoRow('First name', 'Joumana'),
                buildInfoRow('Last name', 'Samy'),
                buildInfoRow('Birth date', '06 June 2003'),
                buildInfoRow('Gender', 'Female'),
                buildInfoRow('City', 'Cairo'),
                buildInfoRow('University', 'CIC'),
                buildInfoRow('Faculty', 'B-TEC'),
                buildInfoRowField('Field', Image.asset('assets/icons/wait.jpg', width: 22, height: 22)),

                SizedBox(height: 20), // Add spacing

                // Contact Information Section
                buildSectionHeader('Contact Information', context),
                buildInfoRow('Email', 'joumanasamy1@gmail.com'),
                buildInfoRow('Phone', '01277481199'),

                SizedBox(height: 27),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Saved Button (Left)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          print('Saved button pressed!');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          textStyle: TextStyle(fontSize: 15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              'assets/icons/bookmark.png',
                              width: 25,
                              height: 25,
                              color: Color(0xFF196AB3),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Saved',
                              style: TextStyle(color: Color(0xFF196AB3)),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Logout Button (Right)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _showLogoutConfirmation(context); // Show confirmation dialog
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          textStyle: TextStyle(fontSize: 15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              'assets/icons/logout (1).png',
                              width: 25,
                              height: 25,
                              color: Colors.red,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Log out',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
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
    );
  }

  Widget buildSectionHeader(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton.icon(
          onPressed: () {
            // Handle edit button press
          },
          icon: Icon(Icons.edit, size: 18),
          label: Text('Edit'),
        ),
      ],
    );
  }

  Widget buildInfoRow(String label, String value, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          if (trailing != null)
            trailing
          else
            Text(value),
        ],
      ),
    );
  }

  Widget buildInfoRowField(String title, Widget value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title), // Text on the left
          value, // Image on the right
        ],
      ),
    );
  }
}