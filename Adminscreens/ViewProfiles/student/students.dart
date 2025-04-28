import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../delete_confirmation_dialog.dart';
import 'edit_student_screen.dart';

class StudentsScreen extends StatefulWidget {
  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<DocumentSnapshot> students = [];

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('users').get();

    setState(() {
      students = snapshot.docs;
    });
  }

  Future<void> deleteStudent(String id) async {
    await FirebaseFirestore.instance.collection('users').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Student deleted successfully")),
    );
    fetchStudents(); // Refresh list after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF2252A1)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Students Profiles",
          style: TextStyle(
            color: Color(0xFF2252A1),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: students.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue[100],
                  child: Icon(Icons.person, size: 40, color: Colors.blue),
                ),
                title: Text(
                  student['firstName'] ?? 'No Name',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student['faculty'] ?? '',
                        style: TextStyle(color: Colors.grey[700])),

                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true, // Makes dialog dismissible by tapping outside
                          builder: (_) => EditStudentDialog(
                            id: student.id,
                            firstName: student['firstName'] ?? '',
                            email: student['email'] ?? '',
                            faculty: student['faculty'] ?? '',
                          ),
                        ).then((_) => fetchStudents());
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDeleteConfirmationDialog(
                          context: context,
                          onConfirm: () => deleteStudent(student.id),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
