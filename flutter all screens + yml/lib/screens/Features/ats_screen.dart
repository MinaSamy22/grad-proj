import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../bottom_navbar.dart'; // Import your BottomNavBar

class AtsScreen extends StatefulWidget {
  static const String routeName = '/AtsScreen';

  const AtsScreen({super.key});

  @override
  _AtsScreenState createState() => _AtsScreenState();
}

class _AtsScreenState extends State<AtsScreen> {
  TextEditingController jobController = TextEditingController();
  File? selectedFile; // Store the selected PDF file
  bool isUploading = false;
  int _selectedIndex = 2; // Set the default index to "Docs" (adjust based on your navigation)

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  void processCV() {
    if (selectedFile != null) {
      setState(() {
        isUploading = true;
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CV Processing Completed!')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload a PDF first!')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('ATS Tracking System'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              'Job description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            TextField(
              controller: jobController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter job description...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue, width: 1.5),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Upload Resume (PDF)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: pickFile,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file, size: 50, color: Colors.blueAccent),
                      SizedBox(height: 10),
                      Text(
                        'Click to upload or drag & drop',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      Text(
                        'PDF only | Max size: 200MB',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (selectedFile != null) ...[
              SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  leading: Icon(Icons.insert_drive_file, color: Colors.blueAccent),
                  title: Text(
                    selectedFile!.path.split('/').last,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        selectedFile = null;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'File uploaded successfully!',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ],
            SizedBox(height: 30),
            isUploading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: processCV,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Center(child: Text('Check the CV', style: TextStyle(fontSize: 16))),
            ),
          ],
        ),
      ),



    );
  }
}