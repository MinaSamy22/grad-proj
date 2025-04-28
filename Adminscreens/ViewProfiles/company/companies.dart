import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_company_screen.dart';
import 'edit_company_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class companies extends StatefulWidget {
  @override
  _CompaniesState createState() => _CompaniesState();
}

class _CompaniesState extends State<companies> {
  final CollectionReference _companyCollection =
  FirebaseFirestore.instance.collection('company');

  // Method to get image URL from Supabase
  Future<String?> _getImageUrl(String companyId) async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('companies_profile')
        .select('img_url')
        .eq('company_id', companyId)
        .single();

    if (response != null) {
      return response['img_url'] as String?;
    } else {
      return null;
    }
  }

  void _deleteCompany(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this company?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () async {
              await _companyCollection.doc(docId).delete();
              Navigator.pop(context);
              _showMessage();
            },
            child: Text("Confirm", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Company deleted successfully"),
        backgroundColor: Color(0xFF196AB3),
        duration: Duration(seconds: 2),
      ),
    );
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Companies Profiles",
          style: TextStyle(color: Color(0xFF2252A1), fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _companyCollection.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final companiesList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: companiesList.length,
              itemBuilder: (context, index) {
                final doc = companiesList[index];
                final data = doc.data() as Map<String, dynamic>;
                final companyId = doc.id; // Firestore doc ID

                return FutureBuilder<String?>(
                  future: _getImageUrl(companyId),
                  builder: (context, imageSnapshot) {
                    if (imageSnapshot.connectionState == ConnectionState.waiting) {
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue[100],
                            child: CircularProgressIndicator(),
                          ),
                          title: Text(
                            data['CompanyName'] ?? 'No Name',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                          subtitle: Text("Email: ${data['Email'] ?? ''}", style: TextStyle(color: Colors.grey[700])),
                        ),
                      );
                    }

                    final imageUrl = imageSnapshot.data;

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue[100],
                          backgroundImage: imageUrl != null
                              ? NetworkImage(imageUrl)
                              : null,
                          child: imageUrl == null
                              ? Icon(Icons.business, size: 40, color: Colors.blue)
                              : null,
                        ),
                        title: Text(
                          data['CompanyName'] ?? 'No Name',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        subtitle: Text("Email: ${data['Email'] ?? ''}", style: TextStyle(color: Colors.grey[700])),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.green),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => EditCompanyDialog(docId: doc.id, data: data),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteCompany(doc.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCompanyScreen()),
          );
        },
        backgroundColor: Color(0xFF2252A1),
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
