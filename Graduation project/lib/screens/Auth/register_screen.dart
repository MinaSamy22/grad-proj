import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = "/RegisterScreen";

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFF0E1339), // Dark background color
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.08),

            // Title
            Center(
              child: Text(
                "Create New Account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Input Fields
            _buildTextField(Icons.person, "Full Name"),
            SizedBox(height: screenHeight * 0.02),
            _buildTextField(Icons.email, "Email"),
            SizedBox(height: screenHeight * 0.02),
            _buildTextField(Icons.calendar_today, "Date of Birth"),
            SizedBox(height: screenHeight * 0.02),
            _buildTextField(Icons.phone, "Phone"),
            SizedBox(height: screenHeight * 0.02),

            // Gender Dropdown
            _buildDropdownField(Icons.wc, "Gender", ["Male", "Female"]),
            SizedBox(height: screenHeight * 0.02),

            _buildTextField(Icons.location_on, "City"),
            SizedBox(height: screenHeight * 0.02),
            _buildTextField(Icons.school, "University"),
            SizedBox(height: screenHeight * 0.02),

            // Faculty Dropdown
            _buildDropdownField(Icons.account_balance, "Faculty", [
              "Business Information System",
              "Information System",
              "Network System",
              "Computer Science",
              "Artificial Intelligence",
              "Engineering-Communication",
              "Engineering-Mechatronics"
            ]),
            SizedBox(height: screenHeight * 0.04),

            // Sign In Button (Navigates to MainScreen)
            Center(child: _buildSignInButton(context)),
            SizedBox(height: screenHeight * 0.02),

            // OR Text
            Center(
              child: Text(
                "Or",
                style: TextStyle(
                  color: Color(0xFF196AB3),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Continue with Google Button (Without Image)
            Center(child: _buildGoogleButton()),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String label) {
    return TextField(
      style: TextStyle(color: Colors.white),
      decoration: _buildInputDecoration(label, icon),
    );
  }

  Widget _buildDropdownField(IconData icon, String label, List<String> items) {
    return DropdownButtonFormField<String>(
      dropdownColor: Color(0xFF1C2C52),
      style: TextStyle(color: Colors.white),
      decoration: _buildInputDecoration(label, icon),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: (value) {},
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      fillColor: Color(0xFF1C2C52),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF196AB3),
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, "/MainScreen"); // ✅ Navigate to MainScreen
      },
      child: Text(
        "Sign In",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () {
        // Handle Google Sign-In Logic
      },
      child: Text(
        "Continue with Google",
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }
}
