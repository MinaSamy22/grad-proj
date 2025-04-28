import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cross_file/cross_file.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as path;

class CourseUploadPage extends StatefulWidget {
  const CourseUploadPage({Key? key}) : super(key: key);

  @override
  _CourseUploadPageState createState() => _CourseUploadPageState();
}

class _CourseUploadPageState extends State<CourseUploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _courseNameController = TextEditingController();
  final _courseDescriptionController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _companyDescriptionController = TextEditingController();
  final _companyLinkController = TextEditingController();
  final _companyContactController = TextEditingController();

  XFile? _courseImage;
  XFile? _companyLogo;
  List<XFile> _roadmapImages = [];
  XFile? _videoFile;

  String? _selectedCategory;
  String? _selectedLevel;

  // Translated categories
  final List<String> _categories = [
    'Programming',
    'Design',
    'Marketing',
    'Management',
    'Data Science',
    'Artificial Intelligence'
  ];

  // Translated levels
  final List<String> _levels = [
    'Beginner',
    'Intermediate',
    'Advanced'
  ];

  List<Map<String, dynamic>> _companies = [];

  final SupabaseClient _supabase = Supabase.instance.client;

  // Define our brand color
  final Color primaryColor = const Color(0xFF2252A1);

  @override
  void dispose() {
    _courseNameController.dispose();
    _courseDescriptionController.dispose();
    _companyNameController.dispose();
    _companyDescriptionController.dispose();
    _companyLinkController.dispose();
    _companyContactController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null) {
        setState(() {
          _courseImage = XFile(result.files.single.path!);
        });
      }
    } else {
      final pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _courseImage = pickedFile;
        });
      }
    }
  }

  Future<void> _pickCompanyLogo() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null) {
        setState(() {
          _companyLogo = XFile(result.files.single.path!);
        });
      }
    } else {
      final pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _companyLogo = pickedFile;
        });
      }
    }
  }

  Future<void> _pickRoadmapImages() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (result != null) {
        setState(() {
          _roadmapImages =
              result.files.map((file) => XFile(file.path!)).toList();
        });
      }
    } else {
      final pickedFiles = await ImagePicker().pickMultiImage();
      if (pickedFiles != null) {
        setState(() {
          _roadmapImages = pickedFiles;
        });
      }
    }
  }

  Future<void> _pickVideo() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );
      if (result != null) {
        setState(() {
          _videoFile = XFile(result.files.single.path!);
        });
      }
    } else {
      final pickedFile = await ImagePicker().pickVideo(
          source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _videoFile = pickedFile;
        });
      }
    }
  }

  Future<String> _uploadFile(XFile file, String bucketName) async {
    final fileExtension = path.extension(file.path);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExtension';
    final fileBytes = await file.readAsBytes();

    await _supabase.storage.from(bucketName).uploadBinary(fileName, fileBytes);

    return _supabase.storage.from(bucketName).getPublicUrl(fileName);
  }

  void _addCompany() {
    if (_companyNameController.text.isEmpty) return;

    setState(() {
      _companies.add({
        'name': _companyNameController.text,
        'description': _companyDescriptionController.text,
        'link': _companyLinkController.text,
        'contact': _companyContactController.text,
        'logo': _companyLogo,
      });

      // Clear fields
      _companyNameController.clear();
      _companyDescriptionController.clear();
      _companyLinkController.clear();
      _companyContactController.clear();
      _companyLogo = null;
    });
  }

  Future<void> _submitCourse() async {
    if (!_formKey.currentState!.validate()) return;
    if (_courseImage == null || _videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course image and video are required')),
      );
      return;
    }

    try {
      // Upload files to Supabase
      final imageUrl = await _uploadFile(_courseImage!, 'course-images');
      final videoUrl = await _uploadFile(_videoFile!, 'course-videos');

      List<String> roadmapUrls = [];
      for (var image in _roadmapImages) {
        final url = await _uploadFile(image, 'roadmap-images');
        roadmapUrls.add(url);
      }

      // Upload course data
      final courseResponse = await _supabase.from('courses').insert({
        'name': _courseNameController.text,
        'description': _courseDescriptionController.text,
        'image_url': imageUrl,
        'video_url': videoUrl,
        'roadmap_images': roadmapUrls,
        'category': _selectedCategory,
        'level': _selectedLevel,
      }).select();

      if (courseResponse.isEmpty) throw Exception('Failed to create course');

      final courseId = courseResponse.first['id'];

      // Upload companies data
      for (var company in _companies) {
        String? logoUrl;
        if (company['logo'] != null) {
          logoUrl = await _uploadFile(company['logo'] as XFile, 'company-logos');
        }

        await _supabase.from('companies').insert({
          'course_id': courseId,
          'name': company['name'],
          'description': company['description'],
          'link': company['link'],
          'contact': company['contact'],
          'logo_url': logoUrl,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course uploaded successfully!')),
      );

      // Reset form
      _formKey.currentState!.reset();
      setState(() {
        _courseImage = null;
        _videoFile = null;
        _roadmapImages = [];
        _companies = [];
      });
    } catch (e) {
      debugPrint('Error occurred: ${e.toString()}');
    }
  }

  Widget _buildImagePreview(XFile? file) {
    if (file == null) return const SizedBox.shrink();

    if (kIsWeb) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          file.path,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(file.path),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  Widget _buildVideoPreview(XFile? file) {
    if (file == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.video_library, size: 40, color: primaryColor),
          const SizedBox(height: 4),
          Text(
            path.basename(file.path),
            style: TextStyle(fontSize: 12, color: primaryColor),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required String label,
    bool isFullWidth = false,
    bool isPrimary = true,
    IconData? icon,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? primaryColor : Colors.white,
          foregroundColor: isPrimary ? Colors.white : primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isPrimary ? BorderSide.none : BorderSide(color: primaryColor),
          ),
          elevation: isPrimary ? 2 : 0,
        ),
        child: Row(
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {IconData? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[700]),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: primaryColor) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Course',
          style: TextStyle(
            color: Color(0xFF2252A1),
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color(0xFF2252A1), // Blue color for leading (back) icon
        ),
      ),

      body: Container(
        color: Colors.grey[50],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Course Information'),

                        // Course Name
                        TextFormField(
                          controller: _courseNameController,
                          decoration: _inputDecoration('Course Name', prefixIcon: Icons.book),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Course name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Course Description
                        TextFormField(
                          controller: _courseDescriptionController,
                          decoration: _inputDecoration('Course Description'),
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Course description is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Course image
                        Text(
                          'Course Image:',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildButton(
                              onPressed: _pickImage,
                              label: 'Image',
                              isPrimary: false,
                              icon: Icons.image,
                            ),
                            const SizedBox(width: 16),
                            if (_courseImage != null)
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: _buildImagePreview(_courseImage),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Course video
                        Text(
                          'Course Video:',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildButton(
                              onPressed: _pickVideo,
                              label: ' Video',
                              isPrimary: false,
                              icon: Icons.video_library,
                            ),
                            const SizedBox(width: 16),
                            if (_videoFile != null)
                              _buildVideoPreview(_videoFile),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Roadmap Images
                        Text(
                          'Roadmap Images:',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildButton(
                          onPressed: _pickRoadmapImages,
                          label: ' Roadmap ',
                          isPrimary: false,
                          icon: Icons.collections,
                        ),
                        const SizedBox(height: 12),
                        if (_roadmapImages.isNotEmpty)
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.all(8),
                              itemCount: _roadmapImages.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey[300]!),
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: Stack(
                                      children: [
                                        _buildImagePreview(_roadmapImages[index]),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _roadmapImages.removeAt(index);
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 20),

                        // Category
                        DropdownButtonFormField<String>(
                          decoration: _inputDecoration('Category', prefixIcon: Icons.category),
                          value: _selectedCategory,
                          items: _categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                          isExpanded: true,
                        ),
                        const SizedBox(height: 16),

                        // Course Level
                        DropdownButtonFormField<String>(
                          decoration: _inputDecoration('Course Level', prefixIcon: Icons.signal_cellular_alt),
                          value: _selectedLevel,
                          items: _levels.map((level) {
                            return DropdownMenuItem(
                              value: level,
                              child: Text(level),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedLevel = value;
                            });
                          },
                          isExpanded: true,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Companies Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Course Providers'),

                        // Company Name
                        TextFormField(
                          controller: _companyNameController,
                          decoration: _inputDecoration('Company Name', prefixIcon: Icons.business),
                        ),
                        const SizedBox(height: 16),

                        // Company Description
                        TextFormField(
                          controller: _companyDescriptionController,
                          decoration: _inputDecoration('Company Description'),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),

                        // Company Link
                        TextFormField(
                          controller: _companyLinkController,
                          decoration: _inputDecoration('Company Website', prefixIcon: Icons.link),
                          keyboardType: TextInputType.url,
                        ),
                        const SizedBox(height: 16),

                        // Contact Information
                        TextFormField(
                          controller: _companyContactController,
                          decoration: _inputDecoration('Contact Information', prefixIcon: Icons.contact_phone),
                        ),
                        const SizedBox(height: 20),

                        // Company Logo
                        Text(
                          'Company Logo:',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildButton(
                              onPressed: _pickCompanyLogo,
                              label: 'Choose Logo',
                              isPrimary: false,
                              icon: Icons.image,
                            ),
                            const SizedBox(width: 16),
                            if (_companyLogo != null)
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: _buildImagePreview(_companyLogo),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Add Company Button
                        Center(
                          child: _buildButton(
                            onPressed: _addCompany,
                            label: 'Add Company',
                            isFullWidth: true,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Added Companies List
                        if (_companies.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Added Companies:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 8),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _companies.length,
                                itemBuilder: (context, index) {
                                  final company = _companies[index];
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ListTile(
                                      leading: company['logo'] != null
                                          ? Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: _buildImagePreview(company['logo']),
                                      )
                                          : Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Icon(Icons.business, color: primaryColor),
                                      ),
                                      title: Text(
                                        company['name'],
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Text(company['description'] ?? ''),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            _companies.removeAt(index);
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Submit Course Button
                _buildButton(
                  onPressed: _submitCourse,
                  label: 'Upload Course',
                  isFullWidth: true,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}