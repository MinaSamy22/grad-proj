import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data'; // added for web
import 'package:flutter/foundation.dart'; // added for kIsWeb
import 'package:supabase_flutter/supabase_flutter.dart';

class AddCompanyScreen extends StatefulWidget {
  @override
  _AddCompanyScreenState createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends State<AddCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  String companyName = '';
  String description = '';
  String email = '';
  String password = '';
  String website = '';

  File? _companyImage;
  Uint8List? _webImage; // added for web image
  bool isLoading = false; // Track loading state

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          pickedFile.readAsBytes().then((value) {
            _webImage = value;
            _companyImage = null;
          });
        } else {
          _companyImage = File(pickedFile.path);
          _webImage = null;
        }
      });
    }
  }

  Future<void> _addCompany() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Set loading state to true
      });

      _formKey.currentState!.save();

      try {
        // Step 1: Add company to Firestore first
        DocumentReference docRef = await FirebaseFirestore.instance.collection('company').add({
          'CompanyName': companyName,
          'Description': description,
          'Email': email,
          'Password': password,
          'Website': website,
        });

        String companyId = docRef.id; // <-- Get the document ID

        // Step 2: Save the companyId to Firestore
        await docRef.update({
          'CompanyID': companyId, // Add the CompanyID field to Firestore
        });

        // Step 3: Upload image to Supabase storage if image exists
        if (_companyImage != null || _webImage != null) {
          final supabase = Supabase.instance.client;
          final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
          final bytes = kIsWeb
              ? _webImage!
              : await _companyImage!.readAsBytes();

          final storageResponse = await supabase.storage
              .from('company-profile-img')
              .uploadBinary(fileName, bytes);

          if (storageResponse.isEmpty) {
            throw Exception('Image upload failed.');
          }

          // Step 4: Get public URL
          final imageUrl = supabase.storage
              .from('company-profile-img')
              .getPublicUrl(fileName);

          // Step 5: Insert into companies_profile table
          await supabase.from('companies_profile').insert({
            'img_url': imageUrl,
            'company_id': companyId,
          });
        }

        setState(() {
          isLoading = false; // Set loading state to false
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Company added successfully',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green[800],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          isLoading = false; // Set loading state to false if there's an error
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add company: $e')),
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
          "Add New Company",
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
                      "This page allows admins to add new companies to the application.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(child: _buildImagePicker()),
                    _buildTextField(
                      "Company Name",
                      Icons.business,
                          (value) => companyName = value!,
                      validator: (value) => value!.isEmpty ? 'Enter company name' : null,
                    ),
                    _buildTextField(
                      "Description",
                      Icons.description,
                          (value) => description = value!,
                      maxLines: 3,
                      validator: (value) => value!.isEmpty ? 'Enter description' : null,
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
                      "Website",
                      Icons.link,
                          (value) => website = value!,
                      validator: (value) => value!.isEmpty ? 'Enter website' : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _addCompany, // Disable button while loading
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2252A1),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        ) // Show loading indicator when loading
                            : const Text(
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
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: _companyImage != null || _webImage != null
                ? ClipOval(
              child: kIsWeb
                  ? Image.memory(_webImage!, fit: BoxFit.cover, width: 120, height: 120)
                  : Image.file(_companyImage!, fit: BoxFit.cover, width: 120, height: 120),
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.image, size: 40, color: Colors.blue),
                Text("Upload Image", style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
