import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Widget pour afficher l'avatar avec support multiple:
/// - URL HTTP (Image.network)
/// - Fichier local (File)
/// - Base64 (data:image/jpeg;base64,...)
/// - Initiales (fallback)
class AvatarImage extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final double size;
  final double borderWidth;

  const AvatarImage({
    super.key,
    this.photoUrl,
    required this.name,
    this.size = 120,
    this.borderWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.mainAppPrimary,
          width: borderWidth,
        ),
      ),
      child: ClipOval(
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    // Pas de photo URL
    if (photoUrl == null || photoUrl!.isEmpty) {
      return _buildInitials();
    }

    final url = photoUrl!;

    // Base64 image
    if (url.startsWith('data:image')) {
      try {
        final base64String = url.split(',')[1];
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: size,
          height: size,
          errorBuilder: (_, __, ___) => _buildInitials(),
        );
      } catch (e) {
        debugPrint('AvatarImage: Error decoding base64 - $e');
        return _buildInitials();
      }
    }

    // Fichier local
    if (url.startsWith('file://')) {
      final filePath = url.substring(7); // Remove 'file://'
      final file = File(filePath);
      return FutureBuilder<bool>(
        future: file.exists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          }
          if (snapshot.data == true) {
            return Image.file(
              file,
              fit: BoxFit.cover,
              width: size,
              height: size,
              errorBuilder: (_, __, ___) => _buildInitials(),
            );
          }
          return _buildInitials();
        },
      );
    }

    // URL HTTP/HTTPS
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: size,
      height: size,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoading();
      },
      errorBuilder: (_, __, ___) => _buildInitials(),
    );
  }

  Widget _buildInitials() {
    final initials = name
        .split(' ')
        .where((s) => s.isNotEmpty)
        .take(2)
        .map((e) => e[0].toUpperCase())
        .join();

    return Container(
      width: size,
      height: size,
      color: AppColors.mainAppPrimary.withValues(alpha: 0.1),
      child: Center(
        child: Text(
          initials.isEmpty ? 'U' : initials,
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
            color: AppColors.mainAppPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      width: size,
      height: size,
      color: Colors.grey.shade100,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainAppPrimary),
        ),
      ),
    );
  }
}
