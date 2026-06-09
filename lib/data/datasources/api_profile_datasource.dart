import 'dart:io';
import 'package:flutter/foundation.dart';

import '../../domain/entities/update_profile_request.dart';
import '../../domain/entities/user_profile.dart';
import '../../services/api/api_client.dart';
import 'profile_datasource.dart';

/// Implémentation API REST du ProfileDataSource
/// 
/// TODO: Implémenter quand le backend Spring Boot est prêt
/// Endpoints attendus:
/// - GET /users/me
/// - PUT /users/me
/// - POST /users/me/avatar (multipart/form-data)
/// - DELETE /users/me/avatar
class ApiProfileDataSource implements ProfileDataSource {
  final ApiClient _apiClient;

  ApiProfileDataSource({
    ApiClient? apiClient,
  }) : _apiClient = apiClient ?? ApiClient();

  @override
  String? get currentUserId {
    // TODO: Récupérer depuis le token JWT décodé
    throw UnimplementedError('currentUserId not implemented for API mode yet');
  }

  @override
  bool get isAuthenticated {
    // TODO: Vérifier si le token JWT est valide
    throw UnimplementedError('isAuthenticated not implemented for API mode yet');
  }

  @override
  Future<UserProfile> getMe() async {
    debugPrint('ApiProfileDataSource: getMe - TODO implement');
    
    // TODO: Implémenter l'appel API
    // final response = await _apiClient.get('/users/me');
    // return UserProfile.fromJson(response);
    
    throw UnimplementedError(
      'API backend not ready yet. '
      'Switch AppConfig.USE_BACKEND_PROFILE to false to use Firebase mode.'
    );
  }

  @override
  Future<UserProfile> updateMe(UpdateProfileRequest request) async {
    debugPrint('ApiProfileDataSource: updateMe - TODO implement');
    
    // TODO: Implémenter l'appel API
    // final response = await _apiClient.put('/users/me', body: request.toMap());
    // return UserProfile.fromJson(response);
    
    throw UnimplementedError(
      'API backend not ready yet. '
      'Switch AppConfig.USE_BACKEND_PROFILE to false to use Firebase mode.'
    );
  }

  @override
  Future<String> uploadAvatar(File image) async {
    debugPrint('ApiProfileDataSource: uploadAvatar - TODO implement');
    
    // TODO: Implémenter l'upload multipart
    // final response = await _apiClient.uploadFile(
    //   '/users/me/avatar',
    //   file: image,
    //   fieldName: 'avatar',
    // );
    // return response['photoUrl'];
    
    throw UnimplementedError(
      'API backend not ready yet. '
      'Switch AppConfig.USE_BACKEND_PROFILE to false to use Firebase mode.'
    );
  }

  @override
  Future<void> deleteAvatar() async {
    debugPrint('ApiProfileDataSource: deleteAvatar - TODO implement');
    
    // TODO: Implémenter l'appel API
    // await _apiClient.delete('/users/me/avatar');
    
    throw UnimplementedError(
      'API backend not ready yet. '
      'Switch AppConfig.USE_BACKEND_PROFILE to false to use Firebase mode.'
    );
  }
}
