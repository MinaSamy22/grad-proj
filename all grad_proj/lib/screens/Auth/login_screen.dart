import 'package:flutter/material.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/LoginScreen";
  
  const LoginScreen({Key? key}) : super(key: key);


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpeg"), // الخلفية
            fit: BoxFit.cover, // تغطية الشاشة بالكامل
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: screenHeight * 0.05,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: screenHeight * 0.1),

                    //Logo
                    Image.asset(
                      'assets/images/logo1.jpeg',
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.1,
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    // ✅ نص الترحيب
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        color: Color(0xFF196AB2),
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // ✅ حقل البريد الإلكتروني
                    TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: _buildInputDecoration("Email", Icons.email),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // ✅ حقل كلمة المرور
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
                    SizedBox(height: screenHeight * 0.03),

                    // ✅ زر تسجيل الدخول
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF196AB3),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.2,
                          vertical: screenHeight * 0.015,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/MainScreen');
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.045),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    // ✅ خيار تسجيل حساب جديد
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "I don't have an account! ",
                          style: TextStyle(color: Colors.black54, fontSize: screenWidth * 0.04),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RegisterScreen.routeName);
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Color(0xFF196AB3), fontSize: screenWidth * 0.04),
                          ),
                        ),
                      ],
                    ),

                    // ✅ نص "أو"
                    Text(
                      "Or",
                      style: TextStyle(
                        color: Color(0xFF196AB3),
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // ✅ زر تسجيل الدخول بجوجل
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                          horizontal: screenWidth * 0.1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        side: BorderSide(color: Colors.blue, width: 2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // تجنب ملء الزر بالكامل
                        children: [
                          Image.asset(
                            "assets/images/google_icon.jpeg", // تأكد من وجود الصورة في assets
                            height: 24, // ضبط الحجم
                            width: 24,
                          ),
                          SizedBox(width: 10), // مسافة بين الأيقونة والنص
                          Text(
                            "Continue with Google",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: screenWidth * 0.042,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ✅ تصميم الحقول
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color(0xFFD9D9D9), fontSize: 16),
      prefixIcon: Icon(icon, color: Colors.blue),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.blue, width: 3),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.blue, width: 3),
      ),
    );
  }
}
