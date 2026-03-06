import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/app_card.dart';

class ProviderProfileEditView extends StatefulWidget {
  const ProviderProfileEditView({super.key});

  @override
  State<ProviderProfileEditView> createState() => _ProviderProfileEditViewState();
}

class _ProviderProfileEditViewState extends State<ProviderProfileEditView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Yassine El Amrani');
  final _emailController = TextEditingController(text: 'yassine.amrani@example.com');
  final _phoneController = TextEditingController(text: '+212 6 12 34 56 78');
  final _titleController = TextEditingController(text: 'Plumber Expert');
  final _bioController = TextEditingController(text: 'Expert plumber with 8 years of experience...');
  int _yearsExperience = 8;

  // NOUVEAU: Photo profile state
  File? _imageFile;
  Map<String, dynamic>? _selectedAvatar;
  final ImagePicker _picker = ImagePicker();

  // NOUVEAU: Liste des avatars avec icônes
  final List<Map<String, dynamic>> _avatarOptions = [
    {'icon': Icons.build_circle, 'color': Color(0xFFFF6B35), 'label': 'Technician'},
    {'icon': Icons.plumbing, 'color': Color(0xFF2196F3), 'label': 'Plumber'},
    {'icon': Icons.electrical_services, 'color': Color(0xFFFFC107), 'label': 'Electrician'},
    {'icon': Icons.format_paint, 'color': Color(0xFFE91E63), 'label': 'Painter'},
    {'icon': Icons.handyman, 'color': Color(0xFF9C27B0), 'label': 'Handyman'},
    {'icon': Icons.cleaning_services, 'color': Color(0xFF00BCD4), 'label': 'Cleaner'},
    {'icon': Icons.carpenter, 'color': Color(0xFF795548), 'label': 'Carpenter'},
    {'icon': Icons.engineering, 'color': Color(0xFF607D8B), 'label': 'Engineer'},
    {'icon': Icons.construction, 'color': Color(0xFFFF9800), 'label': 'Constructor'},
    {'icon': Icons.home_repair_service, 'color': Color(0xFF4CAF50), 'label': 'Home Service'},
    {'icon': Icons.ac_unit, 'color': Color(0xFF00BCD4), 'label': 'AC Technician'},
    {'icon': Icons.grass, 'color': Color(0xFF8BC34A), 'label': 'Gardener'},
  ];

  @override
  void initState() {
    super.initState();
    // Default avatar
    _selectedAvatar = _avatarOptions[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _titleController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // NOUVEAU: Show photo options
  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Profile Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.providerPrimary),
              title: Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                await _pickImageFromGallery();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.providerPrimary),
              title: Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                await _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle, color: AppColors.providerPrimary),
              title: Text('Choose Default Avatar'),
              onTap: () {
                Navigator.pop(context);
                _showDefaultAvatars();
              },
            ),
            if (_imageFile != null || _selectedAvatar != null) ...[
              Divider(),
              ListTile(
                leading: Icon(Icons.delete, color: AppColors.error),
                title: Text('Remove Photo', style: TextStyle(color: AppColors.error)),
                onTap: () {
                  setState(() {
                    _imageFile = null;
                    _selectedAvatar = _avatarOptions[0]; // Reset to default
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // NOUVEAU: Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
          _selectedAvatar = null; // Clear avatar if image is selected
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  // NOUVEAU: Pick image from camera
  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
          _selectedAvatar = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking photo: $e')),
      );
    }
  }

  // NOUVEAU: Show default avatars
  void _showDefaultAvatars() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Choose Avatar'),
        content: Container(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: _avatarOptions.length,
            itemBuilder: (context, index) {
              final avatar = _avatarOptions[index];
              final isSelected = _selectedAvatar != null &&
                  _selectedAvatar!['label'] == avatar['label'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAvatar = avatar;
                    _imageFile = null; // Clear image if avatar is selected
                  });
                  Navigator.pop(context);
                },
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: (avatar['color'] as Color).withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.providerPrimary
                              : AppColors.border,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Icon(
                        avatar['icon'] as IconData,
                        color: avatar['color'] as Color,
                        size: 32,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      avatar['label'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? AppColors.providerPrimary
                            : AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save to backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Profile updated successfully!'),
            ],
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text(
              'Save',
              style: TextStyle(
                color: AppColors.providerPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    body: SafeArea(
    bottom: true,
    child: Form(
    key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // NOUVEAU: Photo de profil avec avatars
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _imageFile == null && _selectedAvatar != null
                          ? (_selectedAvatar!['color'] as Color)
                          .withOpacity(0.1)
                          : AppColors.providerPrimary.withOpacity(0.1),
                      border: Border.all(
                        color: AppColors.providerPrimary.withOpacity(0.3),
                        width: 3,
                      ),
                      image: _imageFile != null
                          ? DecorationImage(
                        image: FileImage(_imageFile!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _imageFile == null
                        ? Icon(
                      _selectedAvatar != null
                          ? _selectedAvatar!['icon'] as IconData
                          : Icons.person,
                      size: 48,
                      color: _selectedAvatar != null
                          ? _selectedAvatar!['color'] as Color
                          : AppColors.providerPrimary,
                    )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showPhotoOptions,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.providerPrimary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: _showPhotoOptions,
                child: Text(
                  'Change Photo',
                  style: TextStyle(
                    color: AppColors.providerPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Personal Information
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16),

            _buildTextField(
              label: 'Full Name',
              controller: _nameController,
              icon: Icons.person_outline,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 16),

            _buildTextField(
              label: 'Email',
              controller: _emailController,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              enabled: false, // Email non modifiable
            ),
            SizedBox(height: 16),

            _buildTextField(
              label: 'Phone',
              controller: _phoneController,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 32),

            // Professional Information
            Text(
              'Professional Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16),

            _buildTextField(
              label: 'Title/Specialty',
              controller: _titleController,
              icon: Icons.work_outline,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 16),

            // Years of Experience
            AppCard(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Years of Experience',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '$_yearsExperience years',
                        style: TextStyle(
                          color: AppColors.providerPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _yearsExperience.toDouble(),
                    min: 0,
                    max: 30,
                    divisions: 30,
                    activeColor: AppColors.providerPrimary,
                    onChanged: (v) {
                      setState(() {
                        _yearsExperience = v.toInt();
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            _buildTextField(
              label: 'About Me',
              controller: _bioController,
              icon: Icons.description_outlined,
              maxLines: 4,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 32),

            // Save Button (large)
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.providerPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      enabled: enabled,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.providerPrimary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.providerPrimary, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
        ),
        filled: !enabled,
        fillColor: enabled ? null : AppColors.border.withOpacity(0.1),
      ),
    );
  }
}