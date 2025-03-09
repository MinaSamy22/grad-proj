import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({Key? key, required this.currentIndex, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // Adjust height if needed
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9), // Light gray background
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25), // Curved corners
          topRight: Radius.circular(25),
        ),


      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, "Home", 0), //navigate to home_screen
          _buildNavItem(Icons.computer, "Courses", 1), //navigate to courses_screen
          _buildNavItem(Icons.receipt_long, "Ats_checker", 2), //navigate to ats_screen
          _buildNavItem(Icons.chat_bubble_outline, "Feedback", 3), //navigate to feedback_screen
          _buildNavItem(Icons.person_outline, "Profile", 4) //navigate to profile_screen
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? Colors.blue : Colors.blue.shade700,
          ),
          if (isSelected)
            Container(
              margin: EdgeInsets.only(top: 4),
              height: 3,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}