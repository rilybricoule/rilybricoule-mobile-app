import 'package:flutter/material.dart';

class LanguagePicker extends StatefulWidget {
  final Color iconColor;
  final Color backgroundColor;

  const LanguagePicker({
    super.key,
    this.iconColor = Colors.white,
    this.backgroundColor = Colors.transparent,
  });

  @override
  State<LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<LanguagePicker> {
  String selectedLanguage = 'EN';

  final Map<String, String> languages = {
    'EN': '🇬🇧',
    'FR': '🇫🇷',
    'AR': '🇲🇦',
  };

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        setState(() {
          selectedLanguage = value;
        });
        print('Language changed to: $value');
        // TODO: Implement actual language change when you add translations
      },
      offset: Offset(0, 45),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      itemBuilder: (BuildContext context) {
        return languages.entries.map((entry) {
          return PopupMenuItem<String>(
            value: entry.key,
            child: Row(
              children: [
                Text(
                  entry.value,
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(width: 12),
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selectedLanguage == entry.key
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: selectedLanguage == entry.key
                        ? Colors.blue[700]
                        : Colors.black87,
                  ),
                ),
                if (selectedLanguage == entry.key) ...[
                  Spacer(),
                  Icon(Icons.check, size: 18, color: Colors.green),
                ],
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.iconColor.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              languages[selectedLanguage]!,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(width: 6),
            Text(
              selectedLanguage,
              style: TextStyle(
                color: widget.iconColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              color: widget.iconColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}