import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SwipeActionButtons extends StatelessWidget {
  final VoidCallback onSkip;
  final VoidCallback onLike;
  final VoidCallback onInfo;

  const SwipeActionButtons({
    super.key,
    required this.onSkip,
    required this.onLike,
    required this.onInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(
          icon: Icons.close,
          color: Colors.red,
          size: 60,
          iconSize: 32,
          onTap: onSkip,
        ),
        const SizedBox(width: 24),
        _buildButton(
          icon: Icons.info_outline,
          color: Colors.blue,
          size: 50,
          iconSize: 26,
          onTap: onInfo,
        ),
        const SizedBox(width: 24),
        _buildButton(
          icon: Icons.favorite,
          color: AppColors.mainAppPrimary,
          size: 60,
          iconSize: 32,
          onTap: onLike,
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required Color color,
    required double size,
    required double iconSize,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: iconSize),
      ),
    );
  }
}
