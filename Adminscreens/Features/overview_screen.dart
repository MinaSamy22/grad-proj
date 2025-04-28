import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Add_screens/Add_Course.dart';
import '../Add_screens/Add_Internship.dart';
import '../Add_screens/add_admins_screen.dart';
import '../ViewProfiles/company/add_company_screen.dart';
import 'Interns_charts _screen.dart';

class OverviewScreen extends StatefulWidget {
  static const String routeName = '/OverviewScreen';

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getStudentCount() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.length;
  }

  Future<int> _getInternshipCount() async {
    final snapshot = await _firestore.collection('interns').get();
    return snapshot.docs.length;
  }

  Future<int> _getCompanyCount() async {
    final snapshot = await _firestore.collection('company').get();
    return snapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Center(
                    child: Text(
                      'Dashboard Overview',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2252A1),
                      ),
                    ),
                  ),
                ),

                // Statistics Cards - Horizontal Scroll
                SizedBox(
                  height: 160,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const SizedBox(width: 4),
                      FutureBuilder<int>(
                        future: _getStudentCount(),
                        builder: (context, snapshot) {
                          return _buildStatCard(
                            context,
                            title: 'Total Students',
                            value: snapshot.hasData ? '${snapshot.data}' : '...',
                            icon: Iconsax.people,
                            color: Colors.blue,
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      FutureBuilder<int>(
                        future: _getInternshipCount(),
                        builder: (context, snapshot) {
                          return _buildStatCard(
                            context,
                            title: 'Active Internships',
                            value: snapshot.hasData ? '${snapshot.data}' : '...',
                            icon: Iconsax.briefcase,
                            color: Colors.green,
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      FutureBuilder<int>(
                        future: _getCompanyCount(),
                        builder: (context, snapshot) {
                          return _buildStatCard(
                            context,
                            title: 'Companies',
                            value: snapshot.hasData ? '${snapshot.data}' : '...',
                            icon: Iconsax.buildings,
                            color: Colors.orange,
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Actions Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Actions',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.4,
                        padding: EdgeInsets.zero,
                        children: [
                          _buildQuickAction(
                              context,
                              icon: Iconsax.add_circle,
                              label: 'Add Course',
                              color: Colors.purple,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CourseUploadPage()),
                                );
                              }
                          ),
                          _buildQuickAction(
                              context,
                              icon: Iconsax.add_square,
                              label: 'Add Internship',
                              color: Colors.green,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddInternship()),
                                );
                              }
                          ),
                          _buildQuickAction(
                              context,
                              icon: Iconsax.user_add,
                              label: 'Add Admin',
                              color: Colors.blue,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddAdminScreen()),
                                );
                              }
                          ),
                          _buildQuickAction(
                            context,
                            icon: Iconsax.building,
                            label: 'Add Company',
                            color: Colors.orange,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddCompanyScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InternsPerCompanyChart(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, {
        required String title,
        required String value,
        required IconData icon,
        required Color color,
      }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 160,
        maxWidth: 180,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                  color: Color(0xFF2252A1)              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.65, // you can make this dynamic if needed
              backgroundColor: Colors.grey[200],
              color: color,
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: color.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                      color: Color(0xFF2252A1)                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
