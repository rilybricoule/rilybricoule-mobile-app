import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../viewmodel/edit_profile_viewmodel.dart';
import '../widgets/avatar_image.dart';

/// Écran d'édition de profil
/// 
/// UX Premium:
/// - Avatar avec caméra (tap pour bottom sheet)
/// - Formulaire avec validation temps réel
/// - Bouton Save désactivé si pas de changement
/// - Snackbar succès/erreur
/// - Loading states
class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  VoidCallback? _listener;

  @override
  void initState() {
    super.initState();
    // Setup listener after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupListener();
    });
  }

  void _setupListener() {
    final viewModel = context.read<EditProfileViewModel>();
    
    _listener = () {
      if (!mounted) return;
      
      final state = viewModel.state;
      
      // Show success only once when transitioning to success state
      if (state == EditProfileState.success) {
        _showSuccessSnackBar();
        // Reset state to prevent showing snackbar again
        viewModel.clearSuccess();
        // Navigate back after showing success
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context, true);
          }
        });
      } else if (state == EditProfileState.error && viewModel.errorMessage != null) {
        // Check if error is retryable (network/server errors)
        final errorMsg = viewModel.errorMessage!.toLowerCase();
        final isRetryable = errorMsg.contains('network') || 
                           errorMsg.contains('timeout') ||
                           errorMsg.contains('connexion') ||
                           errorMsg.contains('server') ||
                           errorMsg.contains('indisponible');
        _showErrorSnackBar(viewModel.errorMessage!, isRetryable: isRetryable);
        viewModel.clearError();
      }
    };
    
    viewModel.addListener(_listener!);
  }

  void _showSuccessSnackBar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.green,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Succès !',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Profil mis à jour avec succès',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(String message, {bool isRetryable = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Erreur',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    message,
                    style: GoogleFonts.poppins(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
        action: isRetryable
            ? SnackBarAction(
                label: 'RÉESSAYER',
                textColor: Colors.white,
                onPressed: () {
                  final viewModel = context.read<EditProfileViewModel>();
                  viewModel.saveProfile();
                },
              )
            : SnackBarAction(
                label: 'FERMER',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
      ),
    );
  }

  @override
  void dispose() {
    // Remove listener before disposing
    if (_listener != null) {
      final viewModel = context.read<EditProfileViewModel>();
      viewModel.removeListener(_listener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Modifier le profil',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          _SaveButton(),
        ],
      ),
      body: Consumer<EditProfileViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.state == EditProfileState.loading && viewModel.profile == null) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainAppPrimary),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Error Banner
                if (viewModel.hasError && viewModel.errorMessage != null)
                  _buildErrorBanner(viewModel.errorMessage!),
                const SizedBox(height: 16),
                const _AvatarSection(),
                const SizedBox(height: 32),
                _buildForm(viewModel),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(EditProfileViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Informations personnelles'),
        const SizedBox(height: 16),
        _buildTextField(
          controller: viewModel.fullNameController,
          label: 'Nom complet',
          hint: 'Votre nom complet',
          icon: Icons.person_outline,
          onChanged: () => viewModel.notifyListeners(),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: viewModel.emailController,
          label: 'Email',
          hint: 'votre@email.com',
          icon: Icons.email_outlined,
          enabled: false,
          helperText: 'L\'email ne peut pas être modifié',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: viewModel.phoneController,
          label: 'Téléphone',
          hint: '+212 6XX XXX XXX',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          onChanged: () => viewModel.notifyListeners(),
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
              if (digitsOnly.length < 8) {
                return 'Le numéro doit contenir au moins 8 chiffres';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 32),
        _buildSectionTitle('Adresse'),
        const SizedBox(height: 16),
        _buildTextField(
          controller: viewModel.cityController,
          label: 'Ville',
          hint: 'Ex: Casablanca',
          icon: Icons.location_city_outlined,
          onChanged: () => viewModel.notifyListeners(),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: viewModel.streetController,
          label: 'Adresse',
          hint: 'Ex: 123 Rue Mohammed V',
          icon: Icons.location_on_outlined,
          maxLines: 2,
          onChanged: () => viewModel.notifyListeners(),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(
                color: AppColors.error,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool enabled = true,
    String? helperText,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    VoidCallback? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        prefixIcon: Icon(icon, color: AppColors.mainAppPrimary),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.mainAppPrimary, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: GoogleFonts.poppins(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey.shade400,
          fontSize: 14,
        ),
        helperStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey.shade500,
        ),
      ),
      validator: validator,
      onChanged: onChanged != null ? (_) => onChanged() : null,
    );
  }
}

/// Bouton Sauvegarder dans l'AppBar (icône check)
class _SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<EditProfileViewModel>(
      builder: (context, viewModel, child) {
        final bool canSave = viewModel.canSave;
        final bool isLoading = viewModel.isLoading;

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: canSave && !isLoading
                ? () => viewModel.saveProfile()
                : null,
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainAppPrimary),
                    ),
                  )
                : Icon(
                    Icons.check,
                    color: canSave ? AppColors.mainAppPrimary : Colors.grey.shade400,
                  ),
            tooltip: 'Enregistrer',
          ),
        );
      },
    );
  }
}

/// Section Avatar avec caméra
class _AvatarSection extends StatelessWidget {
  const _AvatarSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<EditProfileViewModel>(
      builder: (context, viewModel, child) {
        final profile = viewModel.profile;
        final selectedImage = viewModel.selectedImage;
        final isUploading = viewModel.state == EditProfileState.uploadingImage;

        return Center(
          child: Stack(
            children: [
              // Avatar avec AvatarImage widget
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Stack(
                    children: [
                      AvatarImage(
                        photoUrl: selectedImage != null
                            ? 'file://${selectedImage.path}'
                            : (profile?.hasPhoto == true ? profile!.photoUrl : null),
                        name: profile?.fullName ?? 'U',
                        size: 120,
                      ),
                      // Loading overlay when uploading
                      if (isUploading)
                        Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey.shade100.withValues(alpha: 0.9),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainAppPrimary),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              // Bouton caméra
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: isUploading ? null : () => _showImagePickerBottomSheet(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.mainAppPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    final viewModel = context.read<EditProfileViewModel>();
    final hasPhoto = viewModel.profile?.hasPhoto == true;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              
              Text(
                'Photo de profil',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              
              // Prendre une photo
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.mainAppPrimary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: AppColors.mainAppPrimary,
                  ),
                ),
                title: Text(
                  'Prendre une photo',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.takePhoto();
                },
              ),
              
              // Choisir dans la galerie
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.mainAppPrimary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo_library,
                    color: AppColors.mainAppPrimary,
                  ),
                ),
                title: Text(
                  'Choisir dans la galerie',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage();
                },
              ),
              
              // Supprimer la photo (si photo existe)
              if (hasPhoto || viewModel.selectedImage != null)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: AppColors.error,
                    ),
                  ),
                  title: Text(
                    'Supprimer la photo',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.error,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation(context, viewModel);
                  },
                ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, EditProfileViewModel viewModel) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Supprimer la photo ?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Voulez-vous vraiment supprimer votre photo de profil ?',
          style: GoogleFonts.poppins(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Annuler',
              style: GoogleFonts.poppins(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              viewModel.deleteAvatar();
            },
            child: Text(
              'Supprimer',
              style: GoogleFonts.poppins(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}