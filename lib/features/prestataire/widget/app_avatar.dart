import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AppAvatar extends StatelessWidget {
  final double radius;
  final String? imageUrl;
  final String? initials;

  const AppAvatar({
    super.key,
    this.radius = 24,
    this.imageUrl,
    this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Text(
        initials ?? 'YE',
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.5,
        ),
      )
          : null,
    );
  }
}