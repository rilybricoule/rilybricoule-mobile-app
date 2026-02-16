import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String provider; // 'google', 'facebook', 'apple'
  final VoidCallback onPressed;

  const SocialLoginButton({
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getIcon(),
              SizedBox(width: 12),
              Text(
                _getLabel(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getIcon() {
    switch (provider.toLowerCase()) {
      case 'google':
        return Image.asset(
          'assets/images/google_logo.png',
          width: 24,
          height: 24,
        );
      case 'facebook':
        return Icon(Icons.facebook, color: Color(0xFF1877F2), size: 28);
      case 'apple':
        return Icon(Icons.apple, color: Colors.black, size: 28);
      default:
        return Icon(Icons.login, color: Colors.grey);
    }
  }

  String _getLabel() {
    switch (provider.toLowerCase()) {
      case 'google':
        return 'Continue with Google';
      case 'facebook':
        return 'Continue with Facebook';
      case 'apple':
        return 'Continue with Twitter';
      default:
        return 'Continue';
    }
  }
}