import 'dart:io';

import '../entities/user_profile.dart';
import '../entities/update_profile_request.dart';

/// Interface du repository de profil
/// 
/// Cette interface définit le contrat pour toutes les opérations
/// liées au profil utilisateur. L'UI ne connaît que cette interface.
/// 
/// Implémentations:
/// - ProfileRepositoryImpl (data layer) - utilise ProfileDataSource
/// - Peut swap entre FirebaseDataSource et ApiDataSource sans toucher l'UI
abstract class ProfileRepository {
  /// Récupérer le profil de l'utilisateur connecté
  /// 
  /// Retourne le profil complet depuis la source de données
  Future<UserProfile> getMe();

  /// Mettre à jour le profil utilisateur
  /// 
  /// [request] contient uniquement les champs à modifier
  /// Retourne le profil mis à jour
  Future<UserProfile> updateMe(UpdateProfileRequest request);

  /// Uploader un nouvel avatar
  /// 
  /// [image] fichier image à uploader
  /// Retourne l'URL de la photo uploadée
  Future<String> uploadAvatar(File image);

  /// Supprimer l'avatar actuel
  Future<void> deleteAvatar();

  /// Stream du profil utilisateur (pour mises à jour en temps réel)
  /// 
  /// Émet un nouveau profil à chaque modification
  Stream<UserProfile?> get profileStream;

  /// Profil actuellement en cache
  UserProfile? get currentProfile;

  /// Rafraîchir le profil depuis la source de données
  Future<UserProfile?> refreshProfile();

  /// Notifier les listeners d'une mise à jour locale
  /// 
  /// Utile quand le profil est modifié depuis une autre source
  void notifyProfileUpdated(UserProfile profile);
}
