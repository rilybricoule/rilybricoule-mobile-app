import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../home/widgets/provider_card.dart';
import '../viewmodel/search_viewmodel.dart';
import '../../discover_swipe/models/search_context_bundle.dart';
import 'search_map_view.dart';

class SearchView extends StatefulWidget {
  final bool shouldShowFilters;
  final Function(VoidCallback)? onFiltersReady;
  final Function(VoidCallback)? onFocusReady;
  final Function(Function(String))? onQueryReady;
  final String? initialQuery;
  
  const SearchView({
    super.key, 
    this.shouldShowFilters = false, 
    this.onFiltersReady, 
    this.onFocusReady,
    this.onQueryReady,
    this.initialQuery,
  });

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Handle initial query if provided
      if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
        _searchController.text = widget.initialQuery!;
        context.read<SearchViewModel>().search(widget.initialQuery!);
      } else {
        context.read<SearchViewModel>().initialSearch();
      }
      
      // Register the callbacks
      widget.onFiltersReady?.call(_showFilters);
      widget.onFocusReady?.call(() => _focusNode.requestFocus());
      widget.onQueryReady?.call(applyInitialQuery);
      
      if (widget.shouldShowFilters) {
        _showFilters();
      }
    });
    
    // Add listener for instant search
    _searchController.addListener(() {
      final query = _searchController.text;
      context.read<SearchViewModel>().setQuery(query);
      context.read<SearchViewModel>().search();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void applyInitialQuery(String query) {
    _searchController.text = query;
    context.read<SearchViewModel>().search(query);
  }

  void _navigateToSwipe(SearchViewModel viewModel) {
    final bundle = SearchContextBundle(
      query: viewModel.currentQuery,
      categoryId: viewModel.categoryId,
      minRating: viewModel.minRating,
      maxDistanceKm: viewModel.maxDistance,
      availableNow: viewModel.availableNow,
      minPrice: viewModel.minPrice,
      maxPrice: viewModel.maxPrice,
    );

    Navigator.pushNamed(
      context,
      '/discover-swipe',
      arguments: bundle,
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<SearchViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.viewMode == 'map') {
              return SearchMapView(
                onShowFilters: (callback) => _showFilters(),
                onSwitchToList: () => viewModel.setViewMode('list'),
                onSearchTap: () => _focusNode.requestFocus(),
              );
            }

            return Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            _buildResultsHeader(viewModel.providers.length),
                            Expanded(
                              child: viewModel.providers.isEmpty
                                  ? _buildEmptyState()
                                  : _buildProvidersList(viewModel.providers),
                            ),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Rechercher un service...',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onSubmitted: (value) {
                    // Instant search is handled by listener
                  },
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _showFilters,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.mainAppPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: 24),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Consumer<SearchViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  if (viewModel.providers.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => _navigateToSwipe(viewModel),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.mainAppPrimary,
                                AppColors.mainAppPrimary.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.mainAppPrimary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.explore, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Découvrir en swipe',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => viewModel.setViewMode('list'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: viewModel.viewMode == 'list'
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.format_list_bulleted,
                                    size: 18,
                                    color: viewModel.viewMode == 'list'
                                        ? AppColors.mainAppPrimary
                                        : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Liste',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: viewModel.viewMode == 'list'
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: viewModel.viewMode == 'list'
                                          ? AppColors.mainAppPrimary
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => viewModel.setViewMode('map'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: viewModel.viewMode == 'map'
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.map,
                                    size: 18,
                                    color: viewModel.viewMode == 'map'
                                        ? AppColors.mainAppPrimary
                                        : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Carte',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: viewModel.viewMode == 'map'
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: viewModel.viewMode == 'map'
                                          ? AppColors.mainAppPrimary
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader(int count) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '$count PRESTATAIRES TROUVÉS PRÈS DE VOUS',
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildProvidersList(List providers) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: providers.length,
      itemBuilder: (context, index) {
        final provider = providers[index];
        final isBusy = provider.id == '3';

        return Opacity(
          opacity: isBusy ? 0.5 : 1.0,
          child: Stack(
            children: [
              ProviderCard(
                provider: provider,
                onTap: isBusy ? () {} : () {
                  Navigator.pushNamed(
                    context,
                    '/provider-profile',
                    arguments: provider.id,
                  );
                },
              ),
              if (isBusy)
                Positioned.fill(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'OCCUPÉ',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Aucun prestataire trouvé',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late double _minPrice;
  late double _maxPrice;
  late double? _minRating;
  late double _maxDistance;
  late bool _availableNow;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<SearchViewModel>();
    _minPrice = viewModel.minPrice;
    _maxPrice = viewModel.maxPrice;
    _minRating = viewModel.minRating;
    _maxDistance = viewModel.maxDistance;
    _availableNow = viewModel.availableNow;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtres',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _minPrice = 0;
                        _maxPrice = 2000;
                        _minRating = null;
                        _maxDistance = 50;
                        _availableNow = false;
                      });
                    },
                    child: Text(
                      'Tout réinitialiser',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildPriceRange(),
              const SizedBox(height: 24),
              _buildRating(),
              const SizedBox(height: 24),
              _buildDistance(),
              const SizedBox(height: 24),
              _buildAvailability(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final viewModel = context.read<SearchViewModel>();
                    viewModel.setPriceRange(_minPrice, _maxPrice);
                    viewModel.setRating(_minRating);
                    viewModel.setDistance(_maxDistance);
                    viewModel.setAvailableNow(_availableNow);
                    viewModel.search();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainAppPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Appliquer les filtres',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Fourchette de prix (MAD)',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '${_minPrice.toInt()} - ${_maxPrice.toInt()} MAD',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        RangeSlider(
          values: RangeValues(_minPrice, _maxPrice),
          min: 0,
          max: 2000,
          divisions: 20,
          activeColor: AppColors.mainAppPrimary,
          onChanged: (values) {
            setState(() {
              _minPrice = values.start;
              _maxPrice = values.end;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Note',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            _buildRatingChip('Toutes', null),
            _buildRatingChip('4.0+', 4.0),
            _buildRatingChip('4.5+', 4.5),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingChip(String label, double? rating) {
    final isSelected = _minRating == rating;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(label),
          ),
          if (rating != null) ...[
            const SizedBox(width: 4),
            const Icon(Icons.star, size: 14, color: Colors.amber),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _minRating = selected ? rating : null;
        });
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      labelStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected ? AppColors.mainAppPrimary : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDistance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Distance',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Dans un rayon de ${_maxDistance.toInt()}km',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: _maxDistance,
          min: 1,
          max: 50,
          divisions: 49,
          activeColor: AppColors.mainAppPrimary,
          onChanged: (value) {
            setState(() {
              _maxDistance = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAvailability() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Disponible maintenant',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Afficher seulement les prestataires prêts à travailler',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: _availableNow,
          onChanged: (value) {
            setState(() {
              _availableNow = value;
            });
          },
          activeColor: AppColors.mainAppPrimary,
        ),
      ],
    );
  }
}
