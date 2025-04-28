import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCompanyDialog extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  EditCompanyDialog({required this.docId, required this.data});

  @override
  _EditCompanyDialogState createState() => _EditCompanyDialogState();
}

class _EditCompanyDialogState extends State<EditCompanyDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.data['CompanyName']);
    _descController = TextEditingController(text: widget.data['Description']);
    _emailController = TextEditingController(text: widget.data['Email']);
    _passwordController = TextEditingController(text: widget.data['Password']);
    _websiteController = TextEditingController(text: widget.data['Website']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _updateCompany() async {
    await FirebaseFirestore.instance.collection('company').doc(widget.docId).update({
      'CompanyName': _nameController.text,
      'Description': _descController.text,
      'Email': _emailController.text,
      'Password': _passwordController.text,
      'Website': _websiteController.text,
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Company updated successfully"),
      backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Company", style: TextStyle(color: Color(0xFF2252A1))),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(_nameController, "Company Name"),
            SizedBox(height: 10),
            _buildTextField(_emailController, "Email"),
            SizedBox(height: 10),
            _buildTextField(_passwordController, "Password"),
            SizedBox(height: 10),
            _buildTextField(_websiteController, "Website"),
            SizedBox(height: 10),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          onPressed: _updateCompany,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2252A1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
