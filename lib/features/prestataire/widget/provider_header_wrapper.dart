import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/provider_state.dart';
import 'provider_app_header.dart';
import '../view/notifications_view.dart';

class ProviderHeaderWrapper extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool compact;

  const ProviderHeaderWrapper({
    super.key,
    this.scaffoldKey,
    this.compact = true, // Compact par défaut pour les autres pages
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderState>(
      builder: (context, providerState, _) {
        return ProviderAppHeader(
          compact: compact,
          isOnline: providerState.isOnline,
          onOnlineToggle: providerState.toggleOnline,
          notificationCount: providerState.notificationCount,
          onNotificationTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ProviderNotificationsView(),
              ),
            );
          },
          onAvatarTap: () {
            scaffoldKey?.currentState?.openDrawer();
          },
        );
      },
    );
  }
}