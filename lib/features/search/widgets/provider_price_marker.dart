import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/provider_location.dart';

class ProviderPremiumMarker extends StatelessWidget {
  final ProviderLocation provider;
  final bool isSelected;

  const ProviderPremiumMarker({
    super.key,
    required this.provider,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBusy = provider.status == ProviderStatus.busy;
    final primaryColor = AppColors.mainAppPrimary;
    final text = isBusy ? 'OCCUPÉ' : provider.price.split(' ')[0];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isBusy ? Colors.grey[700] : (isSelected ? primaryColor : Colors.white),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isBusy ? Colors.transparent : (isSelected ? Colors.white : Colors.grey[300]!),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isBusy
                      ? Colors.grey[600]
                      : (isSelected ? Colors.white.withOpacity(0.2) : primaryColor.withOpacity(0.1)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 14,
                  color: isBusy ? Colors.white : (isSelected ? Colors.white : primaryColor),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                text,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: isSelected ? 15 : 13,
                  fontWeight: FontWeight.w700,
                  color: isBusy ? Colors.white : (isSelected ? Colors.white : AppColors.textPrimary),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
        CustomPaint(
          size: const Size(12, 8),
          painter: _TrianglePainter(
            color: isBusy ? Colors.grey[700]! : (isSelected ? primaryColor : Colors.white),
            borderColor: isBusy ? Colors.transparent : (isSelected ? Colors.white : Colors.grey[300]!),
          ),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  _TrianglePainter({required this.color, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
