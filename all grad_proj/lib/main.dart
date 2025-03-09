import 'package:flutter/material.dart';
import 'screens/Auth/register_screen.dart';

import 'screens/setup_screens.dart';
import 'screens/splash_screen.dart';
//Auth
import 'screens/Auth/login_screen.dart';
import 'screens/Auth/forgot_password_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//features
import 'screens/Features/main_screen.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized(); // lazm dah etdaf tlma 3mlna t7tih initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // lw el mobile dark mood el app hyb2a kda



      initialRoute: SplashScreen.routeName,


      routes: {

        SplashScreen.routeName: (_) => SplashScreen(),

    //Auth
        SetupScreen.routeName: (_) => const SetupScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => RegisterScreen(),
        ForgotPasswordScreen.routeName: (_) => const ForgotPasswordScreen(),

        //all features inside this
        MainScreen.routeName: (_) => MainScreen(),


    },
    );

  }
}
