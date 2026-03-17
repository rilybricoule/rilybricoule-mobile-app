import 'dart:io';

void main() {
  final files = [
    'lib/features/prestataire/view/mission_details_view.dart',
    'lib/features/prestataire/view/bookings_view.dart',
    'lib/features/prestataire/view/chat/chat_thread_view.dart',
    'lib/features/chat/presentation/widgets/chat_input_bar.dart',
  ];

  for (final file in files) {
    try {
      var content = File(file).readAsStringSync();
      var changed = false;

      // Ensure import
      if (!content.contains('l10n/app_localizations.dart')) {
        content = "import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';\n" + content;
        changed = true;
      }
      
      final replaced = content.replaceAllMapped(RegExp(r'(const\s+)?SnackBar\(content:\s*Text\(([^)]+)\)\)'), (m) {
        return 'SnackBar(content: Text(AppLocalizations.of(context)!.comingSoon))';
      });

      if (replaced != content) {
        content = replaced;
        changed = true;
      }
      
      if (changed) {
        File(file).writeAsStringSync(content);
        print('Updated $file');
      }
    } catch (e) {
      print('Failed on $file: $e');
    }
  }
}
