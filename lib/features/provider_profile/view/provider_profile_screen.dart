import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../data/mock_provider_data.dart';
import '../models/provider_detail_model.dart';
import '../widgets/stat_card.dart';
import '../widgets/service_card.dart';
import '../widgets/review_card.dart';
import '../widgets/rating_summary.dart';
import 'all_services_screen.dart';
import 'all_reviews_screen.dart';
import '../../chat/domain/chat_service.dart';
import '../../chat/domain/exceptions/chat_not_allowed_exception.dart';

class ProviderProfileScreen extends StatefulWidget {
  const ProviderProfileScreen({super.key});

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  bool _isLoading = true;
  bool _isExpanded = false;
  ProviderDetailModel? _provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProvider();
  }

  Future<void> _loadProvider() async {
    final providerId = ModalRoute.of(context)?.settings.arguments as String?;
    
    if (providerId == null) {
      setState(() => _isLoading = false);
      return;
    }

    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _provider = MockProviderData.getProviderById(providerId);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: AppColors.mainAppPrimary)),
      );
    }

    if (_provider == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('RiLyBricoule')),
        body: Center(
          child: Text(
            'Prestataire introuvable',
            style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildHeroSection(),
                    const SizedBox(height: 24),
                    _buildAboutSection(),
                    const SizedBox(height: 16),
                    _buildStatsGrid(),
                    const SizedBox(height: 24),
                    _buildServicesSection(),
                    const SizedBox(height: 24),
                    _buildReviewsSection(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
          _buildBottomCTA(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'RiLyBricoule',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: AppColors.textPrimary),
          onPressed: () {
            final profileLink = 'https://rilybricoule.com/provider/${_provider!.id}';
            Share.share(
              'Découvrez le profil de ${_provider!.name} sur RiLyBricoule\n$profileLink',
              subject: 'Profil de ${_provider!.name}',
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade400, Colors.orange.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          bottom: -60,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      _provider!.avatar,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.person, size: 40),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _provider!.name,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (_provider!.certified)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.mainAppPrimary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.verified,
                                size: 18,
                                color: AppColors.mainAppPrimary,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_provider!.category} • ${_provider!.experience}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Color(0xFFFFC107)),
                          const SizedBox(width: 4),
                          Text(
                            '${_provider!.rating}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            ' (${_provider!.reviewCount} avis)',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 80, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'À propos',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedCrossFade(
            firstChild: Text(
              _provider!.about,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            secondChild: Text(
              _provider!.about,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
          TextButton(
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
            child: Text(
              _isExpanded ? 'Voir moins' : 'Voir plus',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.mainAppPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              icon: Icons.access_time_outlined,
              label: 'RÉPONSE',
              value: _provider!.responseTime,
              iconColor: AppColors.mainAppPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              icon: Icons.check_circle_outline,
              label: 'MISSIONS',
              value: '${_provider!.missionsCount}+',
              iconColor: AppColors.mainAppPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              icon: Icons.verified_user_outlined,
              label: 'STATUT',
              value: 'Certifié',
              iconColor: AppColors.mainAppPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mes Services',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AllServicesScreen(
                        providerName: _provider!.name,
                        services: _provider!.services,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Voir tout',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainAppPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...(_provider!.services.map((service) => ServiceCard(
                service: service,
                onReserve: () {
                  Navigator.pushNamed(
                    context,
                    '/booking-date-time',
                    arguments: {
                      'providerId': _provider!.id,
                      'serviceId': service.id,
                    },
                  );
                },
              ))),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Avis clients',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          RatingSummary(
            rating: _provider!.rating,
            reviewCount: _provider!.reviewCount,
          ),
          const SizedBox(height: 16),
          ...(_provider!.reviews.map((review) => ReviewCard(review: review))),
          Center(
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AllReviewsScreen(
                      providerName: _provider!.name,
                      rating: _provider!.rating,
                      reviewCount: _provider!.reviewCount,
                      reviews: _provider!.reviews,
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.mainAppPrimary),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                'Afficher les ${_provider!.reviewCount} avis',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainAppPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCTA() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_provider!.services.isNotEmpty) {
                    Navigator.pushNamed(
                      context,
                      '/booking-date-time',
                      arguments: {
                        'providerId': _provider!.id,
                        'serviceId': _provider!.services.first.id,
                      },
                    );
                  }
                },
                icon: const Icon(Icons.calendar_today, size: 20),
                label: Text(
                  'Réserver maintenant',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainAppPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(width: 12),
            FutureBuilder<bool>(
              future: ChatService().repository.hasConfirmedBookingWithProvider(_provider!.id),
              builder: (context, snapshot) {
                final hasBooking = snapshot.data ?? false;
                return Tooltip(
                  message: hasBooking ? 'Contacter' : 'Disponible après réservation',
                  child: Container(
                    decoration: BoxDecoration(
                      color: hasBooking 
                        ? AppColors.mainAppPrimary.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: hasBooking ? () => _openChat() : null,
                      icon: const Icon(Icons.chat_bubble_outline),
                      color: hasBooking ? AppColors.mainAppPrimary : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openChat() async {
    try {
      final chatRepo = ChatService().repository;
      final conversation = await chatRepo.getOrCreateConversationWithProvider(_provider!.id);
      
      if (mounted) {
        Navigator.pushNamed(
          context,
          '/chat/${conversation.id}',
          arguments: conversation,
        );
      }
    } on ChatNotAllowedException {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Discussion indisponible',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Le chat est accessible après confirmation de réservation.',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Retour',
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (_provider!.services.isNotEmpty) {
                    Navigator.pushNamed(
                      context,
                      '/booking-date-time',
                      arguments: {
                        'providerId': _provider!.id,
                        'serviceId': _provider!.services.first.id,
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainAppPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Réserver maintenant',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      }
    }
  }
}
