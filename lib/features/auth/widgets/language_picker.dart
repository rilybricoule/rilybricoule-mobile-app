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
        // TODO: Implement language change later
        print('Selected language: $value');
      },
      offset: Offset(0, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      itemBuilder: (BuildContext context) {
        return languages.entries.map((entry) {
          return PopupMenuItem<String>(
            value: entry.key,
            child: Row(
              children: [
                Text(
                  entry.value,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(width: 12),
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: selectedLanguage == entry.key
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                if (selectedLanguage == entry.key)
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.check, size: 18, color: Colors.green),
                  ),
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
            color: widget.iconColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              languages[selectedLanguage]!,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(width: 6),
            Text(
              selectedLanguage,
              style: TextStyle(
                color: widget.iconColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              color: widget.iconColor,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}