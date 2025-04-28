import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditStudentDialog extends StatefulWidget {
  final String id;
  final String firstName;
  final String email;
  final String faculty;

  EditStudentDialog({
    required this.id,
    required this.firstName,
    required this.email,
    required this.faculty,
  });

  @override
  _EditStudentDialogState createState() => _EditStudentDialogState();
}

class _EditStudentDialogState extends State<EditStudentDialog> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController facultyController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.firstName);
    emailController = TextEditingController(text: widget.email);
    facultyController = TextEditingController(text: widget.faculty);
  }

  Future<void> updateStudent() async {
    await FirebaseFirestore.instance.collection('users').doc(widget.id).update({
      'firstName': nameController.text,
      'email': emailController.text,
      'faculty': facultyController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Student updated successfully")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Student", style: TextStyle(color: Color(0xFF2252A1))),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTextField("Name", nameController),
            buildTextField("Email", emailController),
            buildTextField("Faculty", facultyController),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          onPressed: updateStudent,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2252A1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? "Enter $label" : null,
      ),
    );
  }
}
