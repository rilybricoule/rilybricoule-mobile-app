import 'dart:io';

import '../entities/user_profile.dart';

/// Request pour mettre à jour le profil
/// Tous les champs sont optionnels car on peut mettre à jour partiellement
class UpdateProfileRequest {
  final String? fullName;
  final String? phone;
  final UserProfileAddress? address;
  final String? locale;

  const UpdateProfileRequest({
    this.fullName,
    this.phone,
    this.address,
    this.locale,
  });

  /// Vérifier si au moins un champ est présent
  bool get hasChanges =>
      fullName != null ||
      phone != null ||
      address != null ||
      locale != null;

  /// Vérifier la validité de la requête
  String? validate() {
    if (fullName != null && fullName!.length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    
    if (phone != null && phone!.isNotEmpty) {
      // Validation simple: au moins 8 chiffres
      final digitsOnly = phone!.replaceAll(RegExp(r'\D'), '');
      if (digitsOnly.length < 8) {
        return 'Le numéro de téléphone doit contenir au moins 8 chiffres';
      }
    }
    
    return null; // Valide
  }

  /// Convertir en Map pour l'API
  Map<String, dynamic> toMap() {
    return {
      if (fullName != null) 'fullName': fullName,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address!.toMap(),
      if (locale != null) 'locale': locale,
    };
  }

  @override
  String toString() {
    return 'UpdateProfileRequest(fullName: $fullName, phone: $phone, locale: $locale)';
  }
}

/// Request pour upload d'avatar
class UploadAvatarRequest {
  final File imageFile;
  final String? previousPhotoUrl;

  const UploadAvatarRequest({
    required this.imageFile,
    this.previousPhotoUrl,
  });
}
