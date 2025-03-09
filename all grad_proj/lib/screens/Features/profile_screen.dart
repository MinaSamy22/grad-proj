import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Auth/login_screen.dart';
import 'main_screen.dart';
import 'edit_profile_screen.dart'; // Import the EditProfileScreen

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

  // Function to fetch user data as a stream
  Stream<DocumentSnapshot> _fetchUserDataStream() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots();
    }
    return const Stream.empty(); // Return an empty stream if user is not logged in
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: _fetchUserDataStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No user data found.'));
          } else {
            Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
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
                    buildSectionHeader('Personal Information', context, userData),
                    buildInfoRow('First name', userData['firstName'] ?? 'N/A'),
                    buildInfoRow('Last name', userData['lastName'] ?? 'N/A'),
                    buildInfoRow('Birth date', userData['dateOfBirth'] ?? 'N/A'),
                    buildInfoRow('Gender', userData['gender'] ?? 'N/A'),
                    buildInfoRow('City', userData['city'] ?? 'N/A'),
                    buildInfoRow('University', userData['university'] ?? 'N/A'),
                    buildInfoRow('Faculty', userData['faculty'] ?? 'N/A'),
                    buildInfoRowField('Field', Image.asset('assets/icons/wait.jpg', width: 22, height: 22)),

                    SizedBox(height: 20), // Add spacing

                    // Contact Information Section
                    buildSectionHeader('Contact Information', context, userData),
                    buildInfoRow('Email', userData['email'] ?? 'N/A'),
                    buildInfoRow('Phone', userData['phone'] ?? 'N/A'),

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
            );
          }
        },
      ),
    );
  }

  Widget buildSectionHeader(String title, BuildContext context, Map<String, dynamic> userData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton.icon(
          onPressed: () {
            // Navigate to EditProfileScreen with user data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfileScreen(userData: userData),
              ),
            );
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