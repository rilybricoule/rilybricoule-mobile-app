// integration_test/screenshot_test.dart
//
// Automated screenshot capture for RiLyBricoule UI Export
// Run: flutter drive --driver=test_driver/integration_test.dart --target=integration_test/screenshot_test.dart -d <device_id>
//
// This launches the REAL app (with Firebase, FCM, etc.) and captures screenshots.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Import your real main
import 'package:rilybricoule_mobile_app/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Helper: take & save a screenshot
  Future<void> capture(String name) async {
    await Future.delayed(const Duration(milliseconds: 800));
    try {
      await binding.convertFlutterSurfaceToImage();
      final bytes = await binding.takeScreenshot(name);
      final path = 'docs/ui_export/screenshots/$name.png';
      await File(path).create(recursive: true);
      await File(path).writeAsBytes(bytes);
      debugPrint('✅ $name saved ($path)');
    } catch (e) {
      debugPrint('⚠️ $name screenshot failed: $e');
    }
  }

  testWidgets('Capture Auth & Home screens', (tester) async {
    // Launch the full app (exact same as real main())
    app.main();
    
    // Wait for Splash to render
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await capture('001_splash');

    // Wait for Splash auto-navigation
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // At this point we're either on Welcome (not logged in) or Home (logged in).
    // Try to capture what we see:
    final welcomeFinder = find.text('Se connecter');
    
    if (welcomeFinder.evaluate().isNotEmpty) {
      // ─── NOT LOGGED IN PATH ───
      await capture('002_welcome');

      // Go to Login
      await tester.tap(welcomeFinder);
      await tester.pumpAndSettle();
      await capture('003_login');

      // Go to Forgot Password
      final forgotFinder = find.textContaining('oublié');
      if (forgotFinder.evaluate().isNotEmpty) {
        await tester.tap(forgotFinder.first);
        await tester.pumpAndSettle();
        await capture('005_forgot_password');
        
        // Go back
        await tester.tap(find.byType(BackButton).first);
        await tester.pumpAndSettle();
      }

      // Go back to Welcome
      final backButton = find.byType(BackButton);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton.first);
        await tester.pumpAndSettle();
      }

      // Go to Register
      final registerFinder = find.textContaining('inscrire');
      if (registerFinder.evaluate().isNotEmpty) {
        await tester.tap(registerFinder.first);
        await tester.pumpAndSettle();
        await capture('004_register');
      }

      debugPrint('═══ Auth screens captured (001-005). Login to capture more. ═══');
    } else {
      // ─── LOGGED IN → CLIENT HOME PATH ───
      await capture('006_home');

      // Tab 1: Search
      final bottomNav = find.byType(BottomNavigationBar);
      if (bottomNav.evaluate().isNotEmpty) {
        // Search tab (index 1)
        await tester.tap(find.byIcon(Icons.search).last);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        await capture('007_search_list');

        // Reservations tab (index 2)
        await tester.tap(find.byIcon(Icons.calendar_today).last);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        await capture('010_reservations_upcoming');

        // Messages tab (index 3)
        await tester.tap(find.byIcon(Icons.chat_bubble_outline).last);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        await capture('015_conversation_list');

        // Profile tab (index 4)
        await tester.tap(find.byIcon(Icons.person).last);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        await capture('017_profile');

        // Back to Home
        await tester.tap(find.byIcon(Icons.home).last);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Try to tap notifications icon
        final notifIcon = find.byIcon(Icons.notifications_outlined);
        if (notifIcon.evaluate().isNotEmpty) {
          await tester.tap(notifIcon.first);
          await tester.pumpAndSettle(const Duration(seconds: 1));
          await capture('018_notifications_list');
          
          await tester.tap(find.byType(BackButton).first);
          await tester.pumpAndSettle();
        }
      }

      debugPrint('═══ Home + tab screens captured. ═══');
    }

    debugPrint('''
╔══════════════════════════════════════════════════════╗
║  Screenshot capture complete!                        ║
║  Output: docs/ui_export/screenshots/                 ║
║                                                      ║
║  For remaining screens, manually navigate and use:   ║
║  flutter screenshot -d R58M67Y3F1Y                   ║
║  --out=docs/ui_export/screenshots/XXX_name.png       ║
╚══════════════════════════════════════════════════════╝
    ''');
  });
}
