// edit_internship_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditInternshipScreen extends StatefulWidget {
  final Map<String, dynamic> internshipData;
  final Function onUpdate;

  const EditInternshipScreen({
    Key? key,
    required this.internshipData,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _EditInternshipScreenState createState() => _EditInternshipScreenState();
}

class _EditInternshipScreenState extends State<EditInternshipScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for all the fields
  late TextEditingController _companyController;
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _durationController;
  late TextEditingController _responsibilitiesController;
  late TextEditingController _requirementsController;
  late TextEditingController _qualificationsController;
  late TextEditingController _typeController;
  late TextEditingController _internshipTypeController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _companyController = TextEditingController(text: widget.internshipData["companyName"] ?? "");
    _titleController = TextEditingController(text: widget.internshipData["title"] ?? "");
    _locationController = TextEditingController(text: widget.internshipData["location"] ?? "");
    _durationController = TextEditingController(text: widget.internshipData["duration"] ?? "");
    _responsibilitiesController = TextEditingController(text: widget.internshipData["whatYouWillBeDoing"] ?? "");
    _requirementsController = TextEditingController(text: widget.internshipData["whatWeAreLookingFor"] ?? "");
    _qualificationsController = TextEditingController(text: widget.internshipData["preferredQualifications"] ?? "");
    _typeController = TextEditingController(text: widget.internshipData["type"] ?? "");
    _internshipTypeController = TextEditingController(text: widget.internshipData["internship"] ?? "");
  }

  @override
  void dispose() {
    // Dispose all controllers
    _companyController.dispose();
    _titleController.dispose();
    _locationController.dispose();
    _durationController.dispose();
    _responsibilitiesController.dispose();
    _requirementsController.dispose();
    _qualificationsController.dispose();
    _typeController.dispose();
    _internshipTypeController.dispose();
    super.dispose();
  }

  Future<void> _updateInternship() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _firestore.collection('interns').doc(widget.internshipData["id"]).update({
          'company': _companyController.text,
          'title': _titleController.text,
          'location': _locationController.text,
          'duration': _durationController.text,
          'responsibilities': _responsibilitiesController.text,
          'requirements': _requirementsController.text,
          'qualifications': _qualificationsController.text,
          'type': _typeController.text,
          'internship': _internshipTypeController.text,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        widget.onUpdate();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Internship updated successfully",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pop();
      } catch (e) {
        print("Error updating internship: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error updating internship"),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF2252A1)),
        title: Text(
          "Edit Internship",
          style: TextStyle(color: Color(0xFF2252A1), fontSize: 21, fontWeight: FontWeight.bold),
        ),
      ),

      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Company Information"),
                SizedBox(height: 12),
                _buildTextField(
                  controller: _companyController,
                  label: "Company Name",
                  validator: _requiredValidator,
                ),
                SizedBox(height: 16),

                _buildSectionTitle("Internship Details"),
                SizedBox(height: 12),
                _buildTextField(
                  controller: _titleController,
                  label: "Internship Title",
                  validator: _requiredValidator,
                ),
                SizedBox(height: 12),
                _buildTextField(
                  controller: _locationController,
                  label: "Location",
                  validator: _requiredValidator,
                ),
                SizedBox(height: 12),
                _buildTextField(
                  controller: _durationController,
                  label: "Duration",
                  validator: _requiredValidator,
                  hint: "e.g., 3 months, Summer 2025",
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _typeController,
                        label: "Type",
                        validator: _requiredValidator,
                        hint: "e.g., Full-time, Part-time",
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _internshipTypeController,
                        label: "Internship Type",
                        validator: _requiredValidator,
                        hint: "e.g., Paid, Unpaid",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                _buildSectionTitle("Job Description"),
                SizedBox(height: 12),
                _buildTextArea(
                  controller: _responsibilitiesController,
                  label: "What You Will Be Doing",
                  validator: _requiredValidator,
                  hint: "List the responsibilities and tasks",
                  maxLines: 5,
                ),
                SizedBox(height: 12),
                _buildTextArea(
                  controller: _requirementsController,
                  label: "What We Are Looking For",
                  validator: _requiredValidator,
                  hint: "List the key requirements",
                  maxLines: 5,
                ),
                SizedBox(height: 12),
                _buildTextArea(
                  controller: _qualificationsController,
                  label: "Preferred Qualifications",
                  validator: _requiredValidator,
                  hint: "List preferred skills and qualifications",
                  maxLines: 5,
                ),
                SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _updateInternship,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2252A1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Update Internship",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2252A1),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    String? hint,
    required int maxLines,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
      maxLines: maxLines,
      textAlignVertical: TextAlignVertical.top,
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}