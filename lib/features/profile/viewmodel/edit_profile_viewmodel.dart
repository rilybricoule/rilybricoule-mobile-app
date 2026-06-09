import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/update_profile_request.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/repositories/profile_repository.dart';

/// Énumération des états du ViewModel
enum EditProfileState {
  initial,
  loading,
  success,
  error,
  uploadingImage,
}

/// ViewModel pour l'écran d'édition de profil
/// 
/// Gère:
/// - Le chargement du profil
/// - La validation des champs
/// - La détection des modifications (dirty state)
/// - L'upload d'avatar
/// - La sauvegarde des changements
class EditProfileViewModel extends ChangeNotifier {
  final ProfileRepository _profileRepository;
  
  // État
  EditProfileState _state = EditProfileState.initial;
  String? _errorMessage;
  UserProfile? _originalProfile;
  UserProfile? _currentProfile;
  
  // Formulaire
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  
  // Image picker
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  double _uploadProgress = 0.0;

  EditProfileViewModel({
    required ProfileRepository profileRepository,
  }) : _profileRepository = profileRepository {
    // Écouter les changements du repository
    _profileRepository.profileStream.listen((profile) {
      if (profile != null && _state != EditProfileState.loading) {
        _updateFromProfile(profile);
      }
    });
  }

  // Getters publics
  EditProfileState get state => _state;
  String? get errorMessage => _errorMessage;
  UserProfile? get profile => _currentProfile;
  File? get selectedImage => _selectedImage;
  double get uploadProgress => _uploadProgress;
  
  bool get isLoading => _state == EditProfileState.loading || _state == EditProfileState.uploadingImage;
  bool get hasError => _state == EditProfileState.error;
  bool get isSuccess => _state == EditProfileState.success;
  
  /// Vérifier si le formulaire a été modifié
  bool get isDirty {
    if (_originalProfile == null) return false;
    
    return fullNameController.text != _originalProfile!.fullName ||
        phoneController.text != (_originalProfile!.phone ?? '') ||
        cityController.text != (_originalProfile!.address?.city ?? '') ||
        streetController.text != (_originalProfile!.address?.street ?? '') ||
        _selectedImage != null;
  }
  
  /// Vérifier si le formulaire est valide
  bool get isValid {
    // Nom requis, minimum 2 caractères
    if (fullNameController.text.trim().length < 2) return false;
    
    // Téléphone optionnel mais si présent, minimum 8 chiffres
    final phone = phoneController.text.trim();
    if (phone.isNotEmpty) {
      final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
      if (digitsOnly.length < 8) return false;
    }
    
    return true;
  }
  
  /// Le formulaire peut-il être sauvegardé ?
  bool get canSave => isDirty && isValid && !isLoading;

  /// Charger le profil de l'utilisateur
  Future<void> loadProfile() async {
    _setState(EditProfileState.loading);
    _errorMessage = null;
    
    try {
      // Essayer d'abord le cache
      final cachedProfile = _profileRepository.currentProfile;
      if (cachedProfile != null) {
        _updateFromProfile(cachedProfile);
        _setState(EditProfileState.initial);
        return;
      }
      
      // Sinon charger depuis la source
      final profile = await _profileRepository.getMe();
      _updateFromProfile(profile);
      _setState(EditProfileState.initial);
    } catch (e) {
      _errorMessage = 'Erreur chargement profil: $e';
      _setState(EditProfileState.error);
    }
  }
  
  /// Mettre à jour les controllers depuis le profil
  void _updateFromProfile(UserProfile profile) {
    _originalProfile = profile;
    _currentProfile = profile;
    
    fullNameController.text = profile.fullName;
    emailController.text = profile.email;
    phoneController.text = profile.phone ?? '';
    cityController.text = profile.address?.city ?? '';
    streetController.text = profile.address?.street ?? '';
    
    notifyListeners();
  }
  
  /// Prendre une photo avec la caméra
  Future<void> takePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (photo != null) {
        _selectedImage = File(photo.path);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Erreur caméra: $e';
      _setState(EditProfileState.error);
    }
  }
  
  /// Choisir une image depuis la galerie
  Future<void> pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        _selectedImage = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Erreur galerie: $e';
      _setState(EditProfileState.error);
    }
  }
  
  /// Supprimer la photo de profil
  Future<void> deleteAvatar() async {
    // Si on a une image sélectionnée mais pas encore sauvegardée, juste la désélectionner
    if (_selectedImage != null) {
      _selectedImage = null;
      notifyListeners();
      return;
    }
    
    // Si pas de photo existante, rien à faire
    if (_currentProfile?.hasPhoto != true) {
      return;
    }
    
    _setState(EditProfileState.loading);
    
    try {
      await _profileRepository.deleteAvatar();
      
      // Rafraîchir le profil pour avoir les données à jour
      final updatedProfile = await _profileRepository.getMe();
      _originalProfile = updatedProfile;
      _currentProfile = updatedProfile;
      
      _setState(EditProfileState.success);
    } catch (e) {
      _errorMessage = 'Erreur suppression photo: $e';
      _setState(EditProfileState.error);
    }
  }
  
  /// Uploader l'image sélectionnée
  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return null;
    
    _setState(EditProfileState.uploadingImage);
    
    try {
      final photoUrl = await _profileRepository.uploadAvatar(_selectedImage!);
      _selectedImage = null;
      _uploadProgress = 0.0;
      return photoUrl;
    } catch (e) {
      _errorMessage = 'Erreur upload image: $e';
      _setState(EditProfileState.error);
      return null;
    }
  }
  
  /// Sauvegarder les modifications
  Future<bool> saveProfile() async {
    if (!canSave) return false;
    
    _setState(EditProfileState.loading);
    
    try {
      // 1. Uploader l'image si nécessaire
      String? newPhotoUrl;
      if (_selectedImage != null) {
        newPhotoUrl = await _uploadImage();
        if (newPhotoUrl == null && _state == EditProfileState.error) {
          return false;
        }
      }
      
      // 2. Construire la requête de mise à jour
      final request = UpdateProfileRequest(
        fullName: fullNameController.text.trim(),
        phone: phoneController.text.trim().isEmpty 
            ? null 
            : phoneController.text.trim(),
        address: cityController.text.trim().isNotEmpty
            ? UserProfileAddress(
                city: cityController.text.trim(),
                street: streetController.text.trim().isEmpty
                    ? null
                    : streetController.text.trim(),
              )
            : null,
      );
      
      // 3. Envoyer la mise à jour
      final updatedProfile = await _profileRepository.updateMe(request);
      
      // 4. Mettre à jour l'état local
      _originalProfile = updatedProfile;
      _currentProfile = updatedProfile;
      _selectedImage = null;
      
      _setState(EditProfileState.success);
      return true;
    } catch (e) {
      _errorMessage = 'Erreur sauvegarde: $e';
      _setState(EditProfileState.error);
      return false;
    }
  }
  
  /// Réinitialiser le formulaire
  void resetForm() {
    if (_originalProfile != null) {
      _updateFromProfile(_originalProfile!);
    }
    _selectedImage = null;
    _errorMessage = null;
    _setState(EditProfileState.initial);
  }
  
  /// Changer l'état et notifier
  void _setState(EditProfileState state) {
    _state = state;
    notifyListeners();
  }
  
  /// Réinitialiser l'état d'erreur
  void clearError() {
    _errorMessage = null;
    if (_state == EditProfileState.error) {
      _state = EditProfileState.initial;
    }
    notifyListeners();
  }

  /// Réinitialiser l'état de succès (après affichage du snackbar)
  void clearSuccess() {
    if (_state == EditProfileState.success) {
      _state = EditProfileState.initial;
    }
    notifyListeners();
  }
  
  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cityController.dispose();
    streetController.dispose();
    super.dispose();
  }
}
