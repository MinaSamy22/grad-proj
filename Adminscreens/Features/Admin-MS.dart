import 'package:flutter/material.dart';
import 'internship_screen.dart';
import 'overview_screen.dart';
import '../ViewProfiles/profile_screen.dart';
import 'courses_screen.dart';
import '../bottom_navbar.dart'; // Import your custom navbar
class Adminms extends StatefulWidget {
  static const String routeName = '/Adminms';
  @override
  _MainScreenState createState() => _MainScreenState();
}
class _MainScreenState extends State<Adminms> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    OverviewScreen(),
    HomeScreen(),
    CoursesScreen(),
    ViewProfiles()

  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      // Show the screen you choose 3la 7sb
      body: _screens[_selectedIndex],


      bottomNavigationBar: BottomNavBar(  // (BottomNavBar) da el class el fe file buttom_navbar.dart el 3mlt feh design navbar
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // 34an enawar azra2 3la el a5tarto
      ),


    );
  }
}
