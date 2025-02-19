import 'package:flutter/material.dart';
import 'package:project/screens/Auth/register_screen.dart';

import 'screens/setup_screens.dart';
import 'screens/splash_screen.dart';
//Auth
import 'screens/Auth/login_screen.dart';
import 'screens/Auth/forgot_password_screen.dart';
//features
import 'screens/Features/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // lw el mobile dark mood el app hyb2a kda


      // initialRoute: SetupScreen.routeName, (el mfroooood)

      initialRoute: SplashScreen.routeName,


      routes: {

        SplashScreen.routeName: (_) => SplashScreen(),

    //Auth
        SetupScreen.routeName: (_) => const SetupScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        ForgotPasswordScreen.routeName: (_) => const ForgotPasswordScreen(),

        //all features inside this
        MainScreen.routeName: (_) => MainScreen(),


    },
    );

  }
}
