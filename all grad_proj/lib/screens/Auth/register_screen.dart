import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart'; // Import the LoginScreen

class RegisterScreen extends StatefulWidget {
  static const String routeName = "/RegisterScreen";
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var phoneController = TextEditingController();
  var cityController = TextEditingController();
  var universityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  String? selectedGender;
  String? selectedFaculty;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!RegExp(r'^[0-9]{11}$').hasMatch(value)) {
      return 'Phone number must be exactly 11 digits';
    }
    return null;
  }

  String? _validateDropdown(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create user with Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Save additional user details in Firestore
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'firstName': firstNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'dateOfBirth': _dateController.text.trim(),
          'gender': selectedGender,
          'city': cityController.text.trim(),
          'university': universityController.text.trim(),
          'faculty': selectedFaculty,
        });

        // Show success message
        _showCustomSnackBar(
          context,
          'Registration successful! Please log in.',
          Colors.green, // Green for success
        );

        // Navigate to the login screen after successful registration
        Navigator.pushReplacementNamed(context, LoginScreen.routeName); // Replace RegisterScreen with LoginScreen
      } on FirebaseAuthException catch (e) {
        // Handle registration errors
        String errorMessage = 'An error occurred. Please try again.';
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak. Please use a stronger password.';
        }
        _showCustomSnackBar(
          context,
          errorMessage,
          Colors.red, // Red for errors
        );

        // Navigate to the login screen after showing the error message
        Navigator.pushReplacementNamed(context, LoginScreen.routeName); // Navigate to LoginScreen
      } catch (e) {
        _showCustomSnackBar(
          context,
          'Registration successful! Please log in..',
          Colors.green, // Red for errors
        );

        // Navigate to the login screen after showing the error message
        Navigator.pushReplacementNamed(context, LoginScreen.routeName); // Navigate to LoginScreen
      }
    }
  }

  void _showCustomSnackBar(BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background1.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.08,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo1.jpeg',
                  width: screenWidth * 0.6,
                  height: screenHeight * 0.1,
                ),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  "Get Started",
                  style: TextStyle(
                    color: Color(0xFF196AB2),
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.23),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(firstNameController, Icons.person, "First Name", _validateName),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(lastNameController, Icons.person, "Last Name", _validateName),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(emailController, Icons.email, "Email", _validateEmail),
                      SizedBox(height: screenHeight * 0.02),
                      _buildPasswordField(passwordController, "Password", _validatePassword, obscurePassword, () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      }),
                      SizedBox(height: screenHeight * 0.02),
                      _buildPasswordField(confirmPasswordController, "Confirm Password", _validateConfirmPassword, obscureConfirmPassword, () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      }),
                      SizedBox(height: screenHeight * 0.02),
                      _buildDateField(),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(phoneController, Icons.phone, "Phone", _validatePhone),
                      SizedBox(height: screenHeight * 0.02),
                      _buildDropdownField(Icons.wc, "Gender", ["Male", "Female"], _validateDropdown, (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      }),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(cityController, Icons.location_on, "City", _validateName),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(universityController, Icons.school, "University", _validateName),
                      SizedBox(height: screenHeight * 0.02),
                      _buildDropdownField(Icons.account_balance, "Faculty", [
                        "Business Information System",
                        "Information System",
                        "Network System",
                        "Computer Science",
                        "Artificial Intelligence",
                      ], _validateDropdown, (value) {
                        setState(() {
                          selectedFaculty = value;
                        });
                      }),
                      SizedBox(height: screenHeight * 0.04),
                      Center(child: _buildSignupOption()),
                      SizedBox(height: screenHeight * 0.01),
                      Center(child: _buildGoogleSignInButton(screenWidth)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon, String label, String? Function(String?)? validator) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: _buildInputDecoration(label, icon),
      validator: validator,
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, String? Function(String?)? validator, bool obscureText, VoidCallback onToggleVisibility) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black),
      decoration: _buildInputDecoration(label, Icons.lock).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.blue,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      onTap: () => _selectDate(context),
      style: const TextStyle(color: Colors.black),
      decoration: _buildInputDecoration("Date of Birth", Icons.calendar_today),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(IconData icon, String label, List<String> items, String? Function(String?)? validator, Function(String?)? onChanged) {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black),
      decoration: _buildInputDecoration(label, icon),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.blue, fontSize: 16),
      prefixIcon: Icon(icon, color: Colors.blue),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.blue, width: 3),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.blue, width: 3),
      ),
    );
  }

  Widget _buildSignupOption() {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF196AB3),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: _registerUser,
          child: Text(
            "Sign Up",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Or",
          style: TextStyle(
            color: Color(0xFF196AB2),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildGoogleSignInButton(double screenWidth) {
    return OutlinedButton(
      onPressed: () {
        // Handle Google sign-in
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.blue, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/google_icon.jpeg", height: 24, width: 24),
          const SizedBox(width: 10),
          Text(
            "Continue with Google",
            style: TextStyle(
              color: Colors.blue,
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    cityController.dispose();
    universityController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}

