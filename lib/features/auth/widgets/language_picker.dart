import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../language/viewmodel/language_viewmodel.dart';

class LanguagePicker extends StatelessWidget {
  final Color iconColor;
  final Color backgroundColor;

  const LanguagePicker({
    super.key,
    this.iconColor = Colors.white,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    final languageViewModel = Provider.of<LanguageViewModel>(context);
    final currentLocale = languageViewModel.currentLocale;

    return PopupMenuButton<Locale>(
      onSelected: (Locale locale) {
        languageViewModel.changeLocale(locale);
      },
      offset: const Offset(0, 50),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      itemBuilder: (BuildContext context) {
        return LanguageViewModel.supportedLocales.map((locale) {
          final isSelected = currentLocale.languageCode == locale.languageCode;
          return PopupMenuItem<Locale>(
            value: locale,
            child: Row(
              children: [
                Text(
                  languageViewModel.getFlag(locale),
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  locale.languageCode.toUpperCase(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.blue[700] : Colors.black87,
                  ),
                ),
                if (isSelected) ...[
                  const Spacer(),
                  const Icon(Icons.check, size: 18, color: Colors.green),
                ],
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor == Colors.transparent 
              ? iconColor.withOpacity(0.12) 
              : backgroundColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: iconColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              languageViewModel.getFlag(currentLocale),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 8),
            Text(
              currentLocale.languageCode.toUpperCase(),
              style: TextStyle(
                color: iconColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: iconColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}