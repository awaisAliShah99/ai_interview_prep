
import 'package:flutter/material.dart';

import '../../core/services/profile_service.dart';
import 'dart:io';
import '../../core/services/resume_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _experienceController = TextEditingController();
  final _skillsController = TextEditingController();
  final ResumeService _resumeService = ResumeService();

File? _resumeFile;
bool _isUploadingResume = false;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  
Future<void> _loadProfile() async {
  try {
    final snapshot = await _profileService.getProfile();

    if (snapshot.exists) {
      final data = snapshot.data()!;

      _nameController.text = data['fullName'] ?? '';
      _roleController.text = data['targetRole'] ?? '';
      _experienceController.text = data['experience'] ?? '';
      _skillsController.text = data['skills'] ?? '';

      // Resume ka saved path check karna
      final resumePath = data['resumePath'];

      if (resumePath != null) {
        final file = File(resumePath);

        if (await file.exists()) {
          _resumeFile = file;
        }
      }
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


  Future<void> _uploadResume() async {
  setState(() {
    _isUploadingResume = true;
  });

  try {
    final file = await _resumeService.pickAndSaveResume();

    if (file != null && mounted) {
  await _profileService.saveResumePath(file.path);

  if (!mounted) return;

  setState(() {
    _resumeFile = file;
  });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resume uploaded successfully!'),
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resume upload failed: $e')),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        _isUploadingResume = false;
      });
    }
  }
}

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _profileService.saveProfile(
        fullName: _nameController.text.trim(),
        targetRole: _roleController.text.trim(),
        experience: _experienceController.text.trim(),
        skills: _skillsController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile saved successfully!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _experienceController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Professional Profile',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your information to get better interview preparation.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 25),

                    _buildTextField(
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 18),

                    _buildTextField(
                      label: 'Target Job Role',
                      hint: 'e.g. Flutter Developer',
                      controller: _roleController,
                    ),
                    const SizedBox(height: 18),

                    _buildTextField(
                      label: 'Experience',
                      hint: 'e.g. Beginner or 2 years',
                      controller: _experienceController,
                    ),
                    const SizedBox(height: 18),

                    _buildTextField(
                      label: 'Skills',
                      hint: 'e.g. Dart, Flutter, Firebase',
                      controller: _skillsController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),

                    const Text(
  'Upload Resume',
  style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
),

const SizedBox(height: 10),

Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey.shade300),
  ),
  child: Column(
    children: [
      const Icon(
        Icons.picture_as_pdf,
        size: 40,
        color: Colors.deepPurple,
      ),

      const SizedBox(height: 10),

      Text(
        _resumeFile?.path.split('/').last ??
            'No resume selected',
      ),

      const SizedBox(height: 12),

      OutlinedButton.icon(
        onPressed: _isUploadingResume ? null : _uploadResume,
        icon: const Icon(Icons.upload_file),
        label: Text(
          _isUploadingResume
              ? 'Selecting...'
              : 'Choose PDF Resume',
        ),
      ),
    ],
  ),
),

                    const SizedBox(height: 24),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveProfile,
                        child: _isSaving
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Save Profile',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
