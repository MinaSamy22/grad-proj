import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart'; // For generating a unique internshipId

class AddInternship extends StatefulWidget {
  @override
  _AddInternshipScreenState createState() => _AddInternshipScreenState();
}

class _AddInternshipScreenState extends State<AddInternship> {
  final _formKey = GlobalKey<FormState>();
  File? _companyImage;
  String CompanyName = '';
  String title = '';
  String location = '';
  String internship = 'Internship';
  String type = 'On-site';
  String duration = '';
  String whatYouWillBeDoing = '';
  String whatWeAreLookingFor = '';
  String preferredQualifications = '';

  // Firebase initialization
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(); // Initialize Firebase
  }


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print("Form Submitted Successfully");

      // Generate unique internshipId using UUID
      String internshipId = Uuid().v4(); // Generate unique ID for the internship

      // Save data to Firebase
      try {
        await FirebaseFirestore.instance.collection('interns').add({
          'internshipId': internshipId, // Add the unique internship ID
          'companyName': CompanyName,
          'title': title,
          'location': location,
          'internship': internship,
          'type': type,
          'duration': duration,
          'whatYouWillBeDoing': whatYouWillBeDoing,
          'whatWeAreLookingFor': whatWeAreLookingFor,
          'preferredQualifications': preferredQualifications,
          'timestamp': FieldValue.serverTimestamp(), // Add server-generated timestamp
        });

        // Show a success message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Internship added successfully!'),
            backgroundColor: Colors.green, // Green color for success
          ),
        );

        // Navigate back after the submission
        Navigator.pop(context);

      } catch (e) {
        // Show an error message if something goes wrong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add internship: $e'),
            backgroundColor: Colors.red, // Red color for error
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF2252A1)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Add New Internship",
          style: TextStyle(color: Color(0xFF2252A1), fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "This page allows admins to add new internship opportunities to the application, "
                          "enabling students to register for these internships.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10),
                    buildTextField("Company Name", Icons.add_business_outlined, (value) => CompanyName = value!),
                    buildTextField("Internship Title", Icons.work, (value) => title = value!),
                    buildTextField("Location", Icons.location_on, (value) => location = value!),
                    buildDropdownField("Internship", Icons.style_rounded, ["Internship"], (value) => internship = value!),
                    buildDropdownField("Internship Type", Icons.business, ["On-site", "Remote", "Hybrid"], (value) => type = value!),
                    buildTextField("Duration (e.g., 3 months)", Icons.access_time, (value) => duration = value!),
                    buildTextField("What You Will Be Doing", Icons.description, (value) => whatYouWillBeDoing = value!, maxLines: 3),
                    buildTextField("What We Are Looking For", Icons.description_outlined, (value) => whatWeAreLookingFor = value!, maxLines: 3),
                    buildTextField("Preferred Qualifications", Icons.description, (value) => preferredQualifications = value!, maxLines: 3),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2252A1),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget buildTextField(String label, IconData icon, Function(String?) onSaved, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.blue),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
        maxLines: maxLines,
        validator: (value) => value!.isEmpty ? "Enter $label" : null,
        onSaved: onSaved,
      ),
    );
  }

  Widget buildDropdownField(String label, IconData icon, List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: DropdownButtonFormField<String>(
        value: options.contains(type) ? type : options.first,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.blue),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
        items: options.map((option) {
          return DropdownMenuItem(value: option, child: Text(option));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
