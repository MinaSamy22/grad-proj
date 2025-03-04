import 'package:flutter/material.dart';

class ATSMoreInfoScreen extends StatelessWidget {
  static const String routeName = '/ATSMoreInfoScreen';

  const ATSMoreInfoScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light grey background
      appBar: AppBar(
        title: const Text(
          'More Information',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 2, // Slight elevation for depth
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('What is an ATS?'),
            _buildDescription(
              'An Applicant Tracking System (ATS) is a software solution designed to assist HR departments in managing the recruitment process. '
                  'When thousands of resumes are submitted, the ATS scans and filters applications based on job requirements, ensuring that only the most relevant candidates are listed.',
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Tips for Making Your Resume ATS-Friendly'),
            const SizedBox(height: 10),
            Column(
              children: const [

                _TipCard(
                  icon: Icons.spellcheck,
                  title: 'Use Proper Capitalization',
                  description: 'For programming languages and technologies, use correct capitalization (e.g., "C++" instead of "c++").',
                ),

                _TipCard(
                  icon: Icons.text_fields,
                  title: 'Use Correct Terminology',
                  description: 'Write skills and job titles in commonly used formats (e.g., "HTML5" instead of "html").',
                ),
               _TipCard(
                  icon: Icons.search,
                  title: 'Optimize Keywords',
                  description: 'Include keywords from the job description to improve ATS matching.',
                ),
                _TipCard(
                  icon: Icons.save_alt,
                  title: 'Save in an ATS-Compatible Format',
                  description: 'Use PDF to ensure your resume is properly scanned.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to create section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  /// Helper method to create descriptive text
  Widget _buildDescription(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _TipCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blueAccent, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
