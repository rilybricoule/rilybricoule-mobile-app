import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../domain/entities/update_profile_request.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_datasource.dart';

/// Implémentation du ProfileRepository
/// 
/// Fait le lien entre la couche domain (use cases/UI) et la couche data (sources de données).
/// Gère également le caching et les notifications de changement.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource _dataSource;
  
  // Stream controller pour notifier les listeners des changements
  final _profileController = StreamController<UserProfile?>.broadcast();
  
  // Cache du profil courant
  UserProfile? _cachedProfile;

  ProfileRepositoryImpl({
    required ProfileDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  UserProfile? get currentProfile => _cachedProfile;

  @override
  Stream<UserProfile?> get profileStream => _profileController.stream;

  @override
  Future<UserProfile> getMe() async {
    try {
      final profile = await _dataSource.getMe();
      _cachedProfile = profile;
      _profileController.add(profile);
      return profile;
    } catch (e) {
      debugPrint('ProfileRepositoryImpl: getMe error - $e');
      rethrow;
    }
  }

  @override
  Future<UserProfile> updateMe(UpdateProfileRequest request) async {
    try {
      // Validation
      final validationError = request.validate();
      if (validationError != null) {
        throw Exception(validationError);
      }

      debugPrint('ProfileRepositoryImpl: updateMe - $request');

      // Mise à jour via la data source
      final updatedProfile = await _dataSource.updateMe(request);
      
      // Mise à jour du cache et notification
      _cachedProfile = updatedProfile;
      _profileController.add(updatedProfile);

      debugPrint('ProfileRepositoryImpl: Profile updated - ${updatedProfile.fullName}');

      return updatedProfile;
    } catch (e) {
      debugPrint('ProfileRepositoryImpl: updateMe error - $e');
      rethrow;
    }
  }

  @override
  Future<String> uploadAvatar(File image) async {
    try {
      debugPrint('ProfileRepositoryImpl: uploadAvatar');

      final photoUrl = await _dataSource.uploadAvatar(image);
      
      // Rafraîchir le profil pour avoir la nouvelle URL
      await refreshProfile();

      return photoUrl;
    } catch (e) {
      debugPrint('ProfileRepositoryImpl: uploadAvatar error - $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteAvatar() async {
    try {
      debugPrint('ProfileRepositoryImpl: deleteAvatar');

      await _dataSource.deleteAvatar();
      
      // Rafraîchir le profil
      await refreshProfile();
    } catch (e) {
      debugPrint('ProfileRepositoryImpl: deleteAvatar error - $e');
      rethrow;
    }
  }

  @override
  Future<UserProfile?> refreshProfile() async {
    try {
      if (!_dataSource.isAuthenticated) {
        debugPrint('ProfileRepositoryImpl: refreshProfile - not authenticated');
        return null;
      }

      final profile = await _dataSource.getMe();
      _cachedProfile = profile;
      _profileController.add(profile);
      return profile;
    } catch (e) {
      debugPrint('ProfileRepositoryImpl: refreshProfile error - $e');
      return _cachedProfile;
    }
  }

  @override
  void notifyProfileUpdated(UserProfile profile) {
    debugPrint('ProfileRepositoryImpl: notifyProfileUpdated - ${profile.fullName}');
    _cachedProfile = profile;
    _profileController.add(profile);
  }

  /// Libérer les ressources
  void dispose() {
    _profileController.close();
  }
}
