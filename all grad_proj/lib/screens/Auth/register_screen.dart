import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "/RegisterScreen";
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _dateController = TextEditingController();
  bool obscurePassword = true; // ✅ تعريف متغير إخفاء كلمة المرور

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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: Stack(
        children: [
          // الخلفية
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

          // الشعار + Get Started
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

          // محتوى الصفحة القابل للتمرير
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.23),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(Icons.person, "First Name"),
                    SizedBox(height: screenHeight * 0.02),
                    _buildTextField(Icons.person, "Last Name"),
                    SizedBox(height: screenHeight * 0.02),
                    _buildTextField(Icons.email, "Email"),
                    SizedBox(height: screenHeight * 0.02),

                    // ✅ إصلاح حقل إدخال كلمة المرور
                    TextField(
                      obscureText: obscurePassword,
                      style: TextStyle(color: Colors.black),
                      decoration: _buildInputDecoration("Password", Icons.lock).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      style: const TextStyle(color: Colors.black),
                      decoration: _buildInputDecoration("Date of Birth", Icons.calendar_today),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildTextField(Icons.phone, "Phone"),
                    SizedBox(height: screenHeight * 0.02),
                    _buildDropdownField(Icons.wc, "Gender", ["Male", "Female"]),
                    SizedBox(height: screenHeight * 0.02),
                    _buildTextField(Icons.location_on, "City"),
                    SizedBox(height: screenHeight * 0.02),
                    _buildTextField(Icons.school, "University"),
                    SizedBox(height: screenHeight * 0.02),
                    _buildDropdownField(Icons.account_balance, "Faculty", [
                      "Business Information System",
                      "Information System",
                      "Network System",
                      "Computer Science",
                      "Artificial Intelligence",
                    ]),
                    SizedBox(height: screenHeight * 0.04),

                    Center(child: _buildSignupOption()),
                    SizedBox(height: screenHeight * 0.01),
                    Center(child: _buildGoogleSignInButton(screenWidth)), // زر تسجيل الدخول عبر Google
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(IconData icon, String label) {
    return TextField(
      style: const TextStyle(color: Colors.black),
      decoration: _buildInputDecoration(label, icon),
    );
  }

  Widget _buildDropdownField(IconData icon, String label, List<String> items) {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black),
      decoration: _buildInputDecoration(label, icon),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: (value) {},
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
          onPressed: () {
            Navigator.pushNamed(context, '/MainScreen'); // Replace with your home screen route
          },
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
            color: Color(0xFF196AB3),
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
        // وظيفة تسجيل الدخول عبر Google
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
    _dateController.dispose();
    super.dispose();
    }
}
