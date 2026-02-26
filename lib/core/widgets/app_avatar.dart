import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppAvatar extends StatelessWidget {
  final double radius;
  final ImageProvider? image;
  final IconData fallbackIcon;
  final Color? backgroundColor;

  const AppAvatar({
    super.key,
    this.radius = 24,
    this.image,
    this.fallbackIcon = Icons.person,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? AppColors.surface,
        backgroundImage: image,
        child: image == null
            ? Icon(
                fallbackIcon,
                size: radius,
                color: AppColors.primary,
              )
            : null,
      ),
    );
  }
}
