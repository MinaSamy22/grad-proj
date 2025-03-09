import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/LoginScreen";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // Function to show custom SnackBar
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
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Function to handle email/password login
  Future<void> _loginWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Show success message immediately
      _showCustomSnackBar(
        context,
        'Login successful!',
        Colors.green, // Green for success
      );

      // Wait for 2 seconds to allow the user to read the message
      await Future.delayed(Duration(seconds: 2));

      // Navigate to the main screen after the delay
      Navigator.pushReplacementNamed(context, '/MainScreen'); // Use pushReplacementNamed
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Please enter a valid email and password.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No account found with this email. Please check your email or sign up.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password. Please try again.';
      }
      _showCustomSnackBar(
        context,
        errorMessage,
        Colors.red, // Red for errors
      );
    } catch (e) {
      _showCustomSnackBar(
        context,
        'An unexpected error occurred. Please try again.',
        Colors.red, // Red for errors
      );
    }
  }

  // Function to handle Google Sign-In
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Show success message immediately
      _showCustomSnackBar(
        context,
        'Google Sign-In successful! Redirecting to the main screen...',
        Colors.green, // Green for success
      );

      // Wait for 2 seconds to allow the user to read the message
      await Future.delayed(Duration(seconds: 2));

      // Navigate to the main screen after the delay
      Navigator.pushReplacementNamed(context, '/MainScreen'); // Use pushReplacementNamed
    } catch (e) {
      _showCustomSnackBar(
        context,
        'Google Sign-In failed. Please try again.',
        Colors.red, // Red for errors
      );
    }
  }

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
            image: AssetImage("assets/images/background.jpeg"),
            fit: BoxFit.cover,
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

                    // Logo
                    Image.asset(
                      'assets/images/logo1.jpeg',
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.1,
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    // Welcome Text
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        color: Color(0xFF196AB2),
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Email Field
                    TextField(
                      controller: emailController,
                      style: TextStyle(color: Colors.black),
                      decoration: _buildInputDecoration("Email", Icons.email),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Password Field
                    TextField(
                      controller: passwordController,
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

                    // Sign In Button
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
                      onPressed: _loginWithEmailAndPassword,
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.045),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    // Sign Up Option
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

                    // "Or" Text
                    Text(
                      "Or",
                      style: TextStyle(
                        color: Color(0xFF196AB3),
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Continue with Google Button
                    OutlinedButton(
                      onPressed: _signInWithGoogle,
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/google_icon.jpeg",
                            height: 24,
                            width: 24,
                          ),
                          SizedBox(width: 10),
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

  // Input Decoration for TextFields
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