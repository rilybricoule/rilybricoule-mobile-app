import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_status_chip.dart';

class ProviderAppHeader extends StatelessWidget {
  final String userName;
  final bool isOnline;
  final VoidCallback onOnlineToggle;
  final int notificationCount;
  final VoidCallback onNotificationTap;
  final VoidCallback onAvatarTap;
  final bool compact;

  const ProviderAppHeader({
    super.key,
    this.userName = 'Yassine El Amrani',
    required this.isOnline,
    required this.onOnlineToggle,
    this.notificationCount = 0,
    required this.onNotificationTap,
    required this.onAvatarTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: compact
          ? const EdgeInsets.fromLTRB(16, 12, 16, 12)
          : const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.providerPrimary, AppColors.providerAccent],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar cliquable
          GestureDetector(
            onTap: onAvatarTap,
            child: CircleAvatar(
              radius: compact ? 18 : 22,
              backgroundColor: Colors.white,
              child: Text(
                'YE',
                style: TextStyle(
                  color: AppColors.providerPrimary,  // CHANGÉ: Orange au lieu de bleu
                  fontWeight: FontWeight.bold,
                  fontSize: compact ? 12 : 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Nom et status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // "Welcome back" seulement en mode normal
                if (!compact) ...[
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                // Nom
                Text(
                  userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 16 : 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // MODIFIÉ: Status chip avec style blanc
                if (!compact) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          isOnline ? 'Online' : 'Offline',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Notifications + Toggle
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NotificationButton(
                badgeCount: notificationCount,
                onPressed: onNotificationTap,
                compact: compact,
              ),
              // MODIFIÉ: Toggle Online/Offline avec style blanc
              if (!compact) ...[
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: onOnlineToggle,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isOnline
                          ? Colors.white.withOpacity(0.2)
                          : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(isOnline ? 0.5 : 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isOnline ? Icons.wifi : Icons.wifi_off,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 6),
                        Text(
                          isOnline ? 'Online' : 'Offline',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final int badgeCount;
  final VoidCallback onPressed;
  final bool compact;

  const _NotificationButton({
    required this.badgeCount,
    required this.onPressed,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = compact ? 38.0 : 44.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),  // CHANGÉ: Plus visible
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),  // CHANGÉ: Plus visible
                width: 1,
              ),
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: compact ? 20 : 24,
            ),
          ),
        ),
        if (badgeCount > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 5 : 6,
                vertical: compact ? 2 : 3,
              ),
              decoration: BoxDecoration(
                color: Colors.white,  // CHANGÉ: Badge blanc
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: AppColors.providerPrimary,  // CHANGÉ: Border orange
                  width: 2,
                ),
              ),
              child: Text(
                '$badgeCount',
                style: TextStyle(
                  color: AppColors.providerPrimary,  // CHANGÉ: Texte orange
                  fontSize: compact ? 9 : 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );
  }
}