import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Add_screens/Add_Internship.dart';
import '../details/internship_details_screen.dart';
import 'edit_internship_dialog.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> jobList = [];
  List<Map<String, dynamic>> filteredJobList = [];
  Set<String> savedInternshipIds = {}; // store all saved ids here
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInternships();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String searchQuery = _searchController.text.toLowerCase();
    setState(() {
      filteredJobList = jobList.where((job) {
        String title = (job['title'] ?? '').toString().toLowerCase();
        String company = (job['company'] ?? '').toString().toLowerCase();
        String location = (job['location'] ?? '').toString().toLowerCase();
        return title.contains(searchQuery) || company.contains(searchQuery) || location.contains(searchQuery);
      }).toList();
    });
  }

  Future<void> _fetchInternships() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('interns')
          .orderBy('timestamp', descending: true)
          .get();

      QuerySnapshot savedSnapshot = await _firestore
          .collection('Saved_Internships')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      setState(() {
        jobList = querySnapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data["id"] = doc.id;
          return data;
        }).toList();
        filteredJobList = List.from(jobList);

        savedInternshipIds = savedSnapshot.docs
            .map((doc) => (doc.data() as Map<String, dynamic>)['internshipId'] as String)
            .toSet();
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> _refreshInternships() async {
    await _fetchInternships();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.10),
            _buildSearchBar(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.01),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshInternships,
                child: ListView.builder(
                  itemCount: filteredJobList.length,
                  itemBuilder: (context, index) {
                    var job = filteredJobList[index];
                    bool isSaved = savedInternshipIds.contains(job["id"]);
                    return Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                      child: _buildJobCard(job, screenWidth, screenHeight, isSaved),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSearchBar(double screenWidth, double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.06,
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04),
          prefixIcon: Icon(Icons.search, color: Colors.white, size: screenWidth * 0.06),
          filled: true,
          fillColor: Color(0xFF2252A1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddInternship()),
        );
      },
      backgroundColor: Color(0xFF2252A1),
      shape: CircleBorder(),
      child: Icon(Icons.add, color: Colors.white, size: 30),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job, double screenWidth, double screenHeight, bool isSaved) {
    String internshipId = job["id"];
    String userId = FirebaseAuth.instance.currentUser!.uid;

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
                padding: EdgeInsets.all(screenWidth * 0.045),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  job["company"] ?? "Unknown Company",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: Text(
                  job["title"] ?? "Unknown Title",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),

            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            job["location"] ?? "Unknown Location",
            style: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.033),
          ),
          SizedBox(height: screenHeight * 0.015),
          Row(
            children: [
              _buildTag(job["type"] ?? "Unknown Type", Icons.check),
              SizedBox(width: screenWidth * 0.02),
              _buildTag(job["internship"] ?? "Unknown Type", Icons.check),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: screenWidth * 0.5,
                height: screenHeight * 0.04,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InternshipDetailsScreen(internshipData: job),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF196AB3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  label: Text("See More", style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04)),
                  icon: Icon(Icons.trending_up, color: Colors.white, size: screenWidth * 0.05),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.green),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditInternshipScreen(
                            internshipData: job,
                            onUpdate: () {
                              _fetchInternships();
                            },
                          ),
                        ),
                      );
                    },
                    iconSize: screenWidth * 0.05,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteConfirmation(internshipId);
                    },
                    iconSize: screenWidth * 0.05,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(String internshipId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Internship"),
          content: Text("Are you sure you want to delete this internship?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                _deleteInternship(internshipId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteInternship(String internshipId) async {
    try {
      await _firestore.collection('interns').doc(internshipId).delete();
      _fetchInternships();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Internship deleted successfully", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error deleting internship: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting internship"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
