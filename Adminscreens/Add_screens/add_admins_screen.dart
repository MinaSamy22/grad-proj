import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddAdminScreen extends StatefulWidget {

  @override
  _AddAdminScreenState createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  String firstName = '';
  String email = '';
  String password = '';
  String phone = '';
  final String role = 'Super Admin';
  final List<String> permissions = ['edit', 'delete', 'create', 'view'];


  Future<void> _addAdmin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await FirebaseFirestore.instance.collection('admin').add({
          'firstName': firstName,
          'email': email,
          'password': password,
          'phone': phone,
          'role': role,
          'permissions': permissions,
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Admin added successfully',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green[800],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add admin: $e'),
            backgroundColor: Colors.red[800],
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
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2252A1)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add New Admin",
          style: TextStyle(
            color: Color(0xFF2252A1),
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "This page allows super admins to add new admin users to the system.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      "First Name",
                      Icons.person,
                          (value) => firstName = value!,
                      validator: (value) => value!.isEmpty ? 'Enter first name' : null,
                    ),
                    _buildTextField(
                      "Email",
                      Icons.email,
                          (value) => email = value!,
                      validator: (value) => value!.isEmpty ? 'Enter email' : null,
                    ),
                    _buildTextField(
                      "Password",
                      Icons.lock,
                          (value) => password = value!,
                      obscureText: true,
                      validator: (value) => value!.isEmpty ? 'Enter password' : null,
                    ),
                    _buildTextField(
                      "Phone Number",
                      Icons.phone,
                          (value) => phone = value!,
                      validator: (value) => value!.isEmpty ? 'Enter phone number' : null,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _addAdmin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2252A1),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Submit",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
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



  Widget _buildTextField(
      String label,
      IconData icon,
      Function(String?) onSaved, {
        int maxLines = 1,
        bool obscureText = false,
        String? Function(String?)? validator,
        TextInputType? keyboardType,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.blue),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
        maxLines: maxLines,
        obscureText: obscureText,
        validator: validator,
        onSaved: onSaved,
        keyboardType: keyboardType,
      ),
    );
  }
}