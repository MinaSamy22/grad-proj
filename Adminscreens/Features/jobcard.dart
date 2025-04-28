import 'package:flutter/material.dart';

class JobCard extends StatelessWidget {
  final Map<String, String> job;
  final int index;
  final double screenWidth;
  final double screenHeight;
  final Function(int) onDelete;
  const JobCard({
    Key? key,
    required this.job,
    required this.index,
    required this.screenWidth,
    required this.screenHeight,
    required this.onDelete,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue, width: 1.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.049),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  job["company"]!,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: Text(
                  job["title"]!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.green),
                onPressed: () {
                  print("Edit ${job["title"]}");
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(index),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.005),
          Text(
            job["location"]!,
            style: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.033),
          ),
          SizedBox(height: screenHeight * 0.015),
          Row(
            children: [
              _buildTag(job["type1"]!, Icons.check),
              SizedBox(width: screenWidth * 0.02),
              _buildTag(job["type2"]!, Icons.check),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to internship details screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF196AB3),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              icon: Icon(Icons.trending_up, color: Colors.white, size: screenWidth * 0.09),
              label: Text("See More", style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04)),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTag(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.blue, size: 16),
          SizedBox(width: 4),
          Text(text, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}