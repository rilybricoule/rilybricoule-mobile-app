import 'package:flutter/material.dart';

class SocialIconButton extends StatelessWidget {
  final String provider; // 'google', 'facebook', 'twitter'
  final VoidCallback onPressed;

  const SocialIconButton({
    super.key,
    required this.provider,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 70,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: _getIcon(),
        ),
      ),
    );
  }

  Widget _getIcon() {
    switch (provider.toLowerCase()) {
      case 'google':
        return Image.asset(
          'assets/images/google_logo.png',
          width: 28,
          height: 28,
        );
      case 'facebook':
        return Icon(Icons.facebook, color: Color(0xFF1877F2), size: 32);
    case 'twitter':
    case 'x':
    return Container(
    width: 28,
    height: 28,
    decoration: BoxDecoration(
    color: Colors.black,
    borderRadius: BorderRadius.circular(4),
    ),
    child: Center(
    child: Text(
    '𝕏',
    style: TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
      );

      default:
        return Icon(Icons.login, color: Colors.grey, size: 28);
    }
  }
}