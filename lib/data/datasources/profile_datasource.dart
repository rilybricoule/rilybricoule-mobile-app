import 'dart:io';

import '../../domain/entities/update_profile_request.dart';
import '../../domain/entities/user_profile.dart';

/// Interface DataSource pour le profil utilisateur
/// 
/// Définit les opérations de bas niveau pour accéder aux données du profil.
/// Les implémentations peuvent être Firebase, API REST, ou autre.
abstract class ProfileDataSource {
  /// Récupérer le profil de l'utilisateur connecté
  Future<UserProfile> getMe();

  /// Mettre à jour le profil
  Future<UserProfile> updateMe(UpdateProfileRequest request);

  /// Uploader un avatar
  /// Retourne l'URL publique de l'image
  Future<String> uploadAvatar(File image);

  /// Supprimer l'avatar
  Future<void> deleteAvatar();

  /// Récupérer l'UID de l'utilisateur connecté
  String? get currentUserId;

  /// Vérifier si un utilisateur est connecté
  bool get isAuthenticated;
}
