import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import 'chat/chat_thread_view.dart';
import '../domain/conversation_model.dart';

class ProviderMissionDetailsView extends StatefulWidget {
  final String clientName;
  final String serviceName;
  final String address;

  const ProviderMissionDetailsView({
    super.key,
    required this.clientName,
    required this.serviceName,
    required this.address,
  });

  @override
  State<ProviderMissionDetailsView> createState() =>
      _ProviderMissionDetailsViewState();
}

class _ProviderMissionDetailsViewState
    extends State<ProviderMissionDetailsView> {
  int _step = 0;

  final List<String> _statusLabels = [
    'Attente de démarrage',
    'En route',
    'Arrivé sur place',
    'Mission terminée',
  ];

  final List<String> _buttonLabels = [
    'Démarrer le trajet',
    'Arrivé sur place',
    'Terminer la mission',
    'Facturer le client',
  ];

  void _nextStep() {
    setState(() {
      if (_step < 3) {
        _step++;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Affichage de la facture (mock)')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mission en cours'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // NOUVEAU: Show warning dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  icon: Icon(Icons.warning_amber, color: AppColors.warning, size: 48),
                  title: Text('Mission Info'),
                  content: Text(
                    'Important: This is an urgent mission. Please contact the client if you encounter any issues or delays.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Got it'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.error_outline, color: AppColors.error),
          ),
        ],
      ),
    body: SafeArea(
    bottom: true,
    child: Column(
        children: [
          _buildActiveBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                _buildClientCard(),
                const SizedBox(height: 18),
                _buildMapCard(),
                const SizedBox(height: 18),
                _buildTimelineCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    ),
    );
  }

  Widget _buildActiveBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: AppColors.providerPrimary,
      child: Row(
        children: [
          const Icon(Icons.flash_on, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Mission active : ${_statusLabels[_step]}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientCard() {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.providerPrimary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.person, color: AppColors.providerPrimary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.clientName,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                    ),
                    Text(
                      widget.serviceName,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Budget', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                  const Text('250 MAD', style: TextStyle(color: AppColors.providerPrimary, fontWeight: FontWeight.w800, fontSize: 16)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // APPELER
              _buildQuickAction(
                Icons.call,
                'Appeler',
                Colors.green,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Calling ${widget.clientName}...')),
                  );
                },
              ),
              // MESSAGE (CHAT)
              _buildQuickAction(
                Icons.chat_bubble_outline,
                'Message',
                AppColors.providerPrimary,
                onTap: () {
                  // NOUVEAU: Ouvre le chat
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProviderChatThreadView(
                        conversation: Conversation(
                          id: 'conv_${widget.clientName.toLowerCase().replaceAll(' ', '_')}',
                          clientName: widget.clientName,
                          lastMessage: 'Mission accepted: ${widget.serviceName}',
                          timeLabel: 'Now',
                          unreadCount: 0,
                        ),
                      ),
                    ),
                  );
                },
              ),
              // DÉTAILS
              _buildQuickAction(
                Icons.info_outline,
                'Détails',
                AppColors.textSecondary,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mission details')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildMapCard() {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Localisation client', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.navigation, size: 14),
                label: const Text('Itinéraire', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.providerPrimary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Icon(Icons.map, size: 40, color: AppColors.providerPrimary),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.error, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.address,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard() {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Progression de la mission', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 20),
          _buildTimelineStep(0, 'Confirmation de la mission', '10:30'),
          _buildTimelineStep(1, 'Départ du prestataire', '14:05'),
          _buildTimelineStep(2, 'Arrivée sur les lieux', '--:--'),
          _buildTimelineStep(3, 'Mission accomplie', '--:--', isLast: true),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(int stepIndex, String title, String time, {bool isLast = false}) {
    final bool isDone = _step > stepIndex;
    final bool isCurrent = _step == stepIndex;
    final Color color = isDone ? AppColors.success : (isCurrent ? AppColors.providerPrimary : AppColors.border);

    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isDone ? color : Colors.transparent,
                  border: Border.all(color: color, width: 2),
                  shape: BoxShape.circle,
                ),
                child: isDone ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: color,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                    color: isCurrent ? AppColors.textPrimary : AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                if (isCurrent)
                  Text(
                    'En cours...',
                    style: TextStyle(color: AppColors.providerPrimary, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: _nextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: _step == 3 ? AppColors.success : AppColors.providerPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(
            _buttonLabels[_step],
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
        ),
      ),
    );
  }
}