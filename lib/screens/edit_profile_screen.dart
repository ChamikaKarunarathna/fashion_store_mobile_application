import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/app_user.dart';
import '../services/user_service.dart';
import '../theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  final AppUser user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  bool _isSaving = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _phoneController = TextEditingController(text: widget.user.phone ?? '');
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      String? photoUrl = widget.user.photoUrl;

      if (_imageFile != null) {
        photoUrl = await _userService.uploadProfilePicture(widget.user.id, _imageFile!);
      }

      final updatedUser = AppUser(
        id: widget.user.id,
        email: widget.user.email, // Email change requires Firebase Auth re-auth, keeping as is
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: widget.user.address,
        city: widget.user.city,
        zip: widget.user.zip,
        photoUrl: photoUrl,
        createdAt: widget.user.createdAt,
      );

      await _userService.updateUser(widget.user.id, updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: AppTheme.textDark, size: 20),
        ),
        title: Text(
          'EDIT PROFILE',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.0,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppTheme.borderGrey.withValues(alpha: 0.5),
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!) as ImageProvider
                            : (widget.user.photoUrl != null
                                ? NetworkImage(widget.user.photoUrl!)
                                : null),
                        child: (_imageFile == null && widget.user.photoUrl == null)
                            ? const Icon(Icons.person, size: 50, color: AppTheme.textGrey)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              _buildInputLabel('FULL NAME'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: _buildInputDecoration(Icons.person_outline),
                validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 24),
              
              _buildInputLabel('PHONE NUMBER'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _buildInputDecoration(Icons.phone_outlined, hint: 'e.g. +1 234 567 8900'),
              ),
              const SizedBox(height: 24),

              _buildInputLabel('EMAIL ADDRESS'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                enabled: false,
                decoration: _buildInputDecoration(Icons.email_outlined).copyWith(
                  fillColor: AppTheme.borderGrey.withValues(alpha: 0.2),
                  filled: true,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Email address cannot be changed.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textLightGrey,
                    ),
              ),
              const SizedBox(height: 48),

              ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: AppTheme.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'SAVE CHANGES',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1.0,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: AppTheme.textGrey,
        letterSpacing: 0.5,
      ),
    );
  }

  InputDecoration _buildInputDecoration(IconData icon, {String? hint}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppTheme.textGrey, size: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppTheme.borderGrey.withValues(alpha: 0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppTheme.primaryGreen),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}
