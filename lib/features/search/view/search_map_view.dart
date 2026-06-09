import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/location/location_service.dart';
import '../models/provider_location.dart';
import '../models/swipe_filter_state.dart';
import '../widgets/provider_price_marker.dart';
import '../widgets/provider_preview_card.dart';
import '../widgets/swipe_filter_deck.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/models/provider_model.dart';

class SearchMapView extends StatefulWidget {
  final Function(VoidCallback) onShowFilters;
  final VoidCallback onSwitchToList;
  final VoidCallback? onSearchTap;
  final List<ProviderModel> providers;
  final bool isLoading;

  const SearchMapView({
    super.key,
    required this.onShowFilters,
    required this.onSwitchToList,
    this.onSearchTap,
    required this.providers,
    required this.isLoading,
  });

  @override
  State<SearchMapView> createState() => _SearchMapViewState();
}

class _SearchMapViewState extends State<SearchMapView> {
  GoogleMapController? _mapController;
  String? _selectedProviderId;
  final Set<Marker> _markers = {};
  String? _errorMessage;
  final Map<String, GlobalKey> _markerKeys = {};
  LocationPermissionStatus? _permissionStatus;
  Position? _currentPosition;
  final _locationService = LocationService();
  bool _hasCenteredInitially = false;
  List<ProviderLocation> _mappedProviders = [];

  // ─── Swipe Filter ───
  SwipeFilterState _swipeState = const SwipeFilterState();

  /// Providers visible on the map after swipe filter is applied.
  List<ProviderLocation> get _visibleProviders =>
      _swipeState.applyFilter(_mappedProviders);

  List<ProviderLocation> _mapToLocations(List<ProviderModel> models) {
    final coordinates = [
      const LatLng(33.8200, -6.9200), // Tamesna
      const LatLng(33.9167, -6.9167), // Temara
      const LatLng(33.8500, -7.0300), // Skhirat
      const LatLng(33.7800, -6.7900), // Ain Aouda
      const LatLng(33.9400, -6.9500), // Harhoura
      const LatLng(33.8800, -6.9800),
    ];
    
    return models.asMap().entries.map((entry) {
      final index = entry.key;
      final model = entry.value;
      return ProviderLocation(
        id: model.id,
        name: model.name,
        category: model.service,
        imageUrl: model.imageUrl,
        rating: model.rating,
        reviewCount: model.reviewCount,
        distance: model.distance,
        price: model.price,
        position: coordinates[index % coordinates.length],
        isVerified: model.isVerified,
        status: model.isAvailableNow ? ProviderStatus.available : ProviderStatus.busy,
        categoryId: model.categoryId,
        activeJobsCount: model.activeJobsCount,
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _mappedProviders = _mapToLocations(widget.providers);
    _initializeMap();
  }

  @override
  void didUpdateWidget(SearchMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isLoading && widget.providers != oldWidget.providers) {
      _mappedProviders = _mapToLocations(widget.providers);
      _errorMessage = null;
      if (widget.providers.isNotEmpty) {
        _createMarkers();
      } else {
        setState(() {
          _markers.clear();
          _selectedProviderId = null;
        });
      }
    }
  }

  Future<void> _initializeMap() async {
    final permissionStatus = await _locationService.checkPermission();
    setState(() => _permissionStatus = permissionStatus);

    if (permissionStatus == LocationPermissionStatus.granted) {
      await _loadUserLocation();
    }
  }

  Future<void> _loadUserLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();
      if (position == null) {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.errorGettingLocation;
        });
        return;
      }

      setState(() => _currentPosition = position);

      if (widget.providers.isNotEmpty) {
        await _createMarkers();
      }

      if (!_hasCenteredInitially && _mapController != null) {
        _hasCenteredInitially = true;
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            13,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _createMarkers() async {
    // Wait for the hidden widgets to be fully mounted and painted by the Flutter engine
    await Future.delayed(const Duration(milliseconds: 150));
    _markers.clear();

    for (var provider in _visibleProviders) {
      final key = _markerKeys[provider.id];
      if (key == null) continue;

      try {
        final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
        if (boundary == null) continue;

        ui.Image? image;
        int retries = 0;
        // Even mounted widgets might need a frame to finish async fonts/images
        while (image == null && retries < 15) {
          try {
            image = await boundary.toImage(pixelRatio: 2.5);
          } catch (_) {
            retries++;
            await Future.delayed(const Duration(milliseconds: 20));
          }
        }

        if (image != null) {
          final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
          final bytes = byteData!.buffer.asUint8List();

          _markers.add(Marker(
            markerId: MarkerId(provider.id),
            position: provider.position,
            icon: BitmapDescriptor.fromBytes(bytes),
            onTap: () => _onMarkerTapped(provider.id),
            anchor: const Offset(0.5, 1.0),
          ));
        }
      } catch (e) {
        // Skip if snapshot fails
      }
    }
    if (mounted) setState(() {});
  }

  void _onMarkerTapped(String providerId) async {
    setState(() => _selectedProviderId = providerId);
    await _createMarkers();
  }

  Future<void> _requestPermission() async {
    final status = await _locationService.requestPermission();
    setState(() {
      _permissionStatus = status;
      _errorMessage = null;
    });

    if (status == LocationPermissionStatus.granted) {
      await _initializeMap();
    } else if (status == LocationPermissionStatus.deniedForever) {
      await _locationService.openAppSettings();
    }
  }

  Future<void> _enableLocation() async {
    await _locationService.openLocationSettings();
    await Future.delayed(const Duration(seconds: 1));
    await _initializeMap();
  }

  void _recenterMap() async {
    final position = await _locationService.getCurrentPosition();
    if (position != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          13,
        ),
      );
    }
  }

  ProviderLocation? get _selectedProvider {
    if (_selectedProviderId == null) return null;
    try {
      return _mappedProviders.firstWhere((p) => p.id == _selectedProviderId);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.mainAppPrimary),
      );
    }

    if (_permissionStatus == LocationPermissionStatus.denied ||
        _permissionStatus == LocationPermissionStatus.deniedForever) {
      return _buildPermissionDenied();
    }

    if (_permissionStatus == LocationPermissionStatus.disabled) {
      return _buildLocationDisabled();
    }

    if (_errorMessage != null) {
      return _buildError();
    }

    if (_visibleProviders.isEmpty) {
      return Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(_currentPosition?.latitude ?? 33.8200, _currentPosition?.longitude ?? -6.9200),
              zoom: 13,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              if (!_hasCenteredInitially && _currentPosition != null) {
                _hasCenteredInitially = true;
                _mapController!.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                    13,
                  ),
                );
              }
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          _buildSearchBar(),
          _buildMapControls(),
          _buildShowListButton(),
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline, color: AppColors.textSecondary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.noProviderInThisArea,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        // Hidden map markers for rendering
        Positioned(
          top: -2000,
          left: 0,
          child: Material(
            type: MaterialType.transparency,
            child: Row(
              children: _visibleProviders.map((p) {
                _markerKeys[p.id] ??= GlobalKey();
                return RepaintBoundary(
                    key: _markerKeys[p.id],
                    child: ProviderPremiumMarker(
                      provider: p,
                      isSelected: _selectedProviderId == p.id,
                    ),
                  );
              }).toList(),
            ),
          ),
        ),
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(_currentPosition?.latitude ?? 33.8200, _currentPosition?.longitude ?? -6.9200),
            zoom: 13,
          ),
          markers: _markers,
          onMapCreated: (controller) => _mapController = controller,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          onTap: (_) {
            if (_selectedProviderId != null) {
              setState(() => _selectedProviderId = null);
              _createMarkers();
            }
          },
        ),
        // Swipe filter active chip
        if (_swipeState.isFilterApplied && !_swipeState.isSessionActive && _selectedProvider == null)
          _buildSwipeActiveChip(),
        // Swipe filter FAB and List button (only when deck is NOT open, and no provider selected)
        if (!_swipeState.isSessionActive && _selectedProvider == null) ...[
          _buildSwipeFilterFab(),
          _buildShowListButton(),
        ],
        if (_selectedProvider != null && !_swipeState.isSessionActive)
          _buildProviderPreview(),
        _buildMapControls(),
        _buildSearchBar(), // Elevated Z-index to prevent MapControls overlap
        // Swipe deck overlay
        if (_swipeState.isSessionActive)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SwipeFilterDeck(
              providers: _mappedProviders,
              currentIndex: _swipeState.currentIndex,
              likedIds: _swipeState.likedProviderIds,
              dislikedIds: _swipeState.dislikedProviderIds,
              onSwipe: _onSwipeDecision,
              onDone: _onSwipeDone,
              onReset: _onSwipeReset,
            ),
          ),
      ],
    );
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 80, color: AppColors.textSecondary),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.locationPermissionRequired,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.locationPermissionDesc,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _requestPermission,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainAppPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.allowLocation,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationDisabled() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_disabled, size: 80, color: AppColors.textSecondary),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.gpsDisabled,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.gpsDisabledDesc,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _enableLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainAppPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.enableLocation,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: AppColors.error),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.errorTitle,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage ?? AppLocalizations.of(context)!.errorOccurred,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _initializeMap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainAppPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.retry,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_search, size: 80, color: AppColors.textSecondary),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.noProviderFound,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.noProvidersInYourArea,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.onSwitchToList();
                widget.onSearchTap?.call();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.textSecondary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.searchService,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                color: AppColors.mainAppPrimary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  widget.onShowFilters(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: const Icon(Icons.tune, color: Colors.white, size: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      top: 90,
      right: 16,
      child: Column(
        children: [
          _buildControlButton(
            icon: Icons.my_location,
            onTap: _recenterMap,
          ),
          const SizedBox(height: 8),
          _buildControlButton(
            icon: Icons.add,
            onTap: () {
              _mapController?.animateCamera(CameraUpdate.zoomIn());
            },
          ),
          const SizedBox(height: 8),
          _buildControlButton(
            icon: Icons.remove,
            onTap: () {
              _mapController?.animateCamera(CameraUpdate.zoomOut());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildShowListButton() {
    return Positioned(
      bottom: 32,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: widget.onSwitchToList,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.format_list_bulleted,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.showList,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProviderPreview() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: ProviderPreviewCard(
          provider: _selectedProvider!,
          onClose: () {
            setState(() => _selectedProviderId = null);
            _createMarkers();
          },
          onTap: () {
            Navigator.pushNamed(
              context,
              '/provider-profile',
              arguments: _selectedProvider!.id,
            );
          },
          onReserve: () {
            Navigator.pushNamed(
              context,
              '/booking-date-time',
              arguments: {
                'providerId': _selectedProvider!.id,
                'serviceId': 's1',
              },
            );
          },
        ),
      ),
    );
  }

  // ─── Swipe Filter ───────────────────────────────────────

  Widget _buildSwipeFilterFab() {
    final hasProviders = _mappedProviders.isNotEmpty;
    return Positioned(
      bottom: 90,
      right: 16,
      child: GestureDetector(
        onTap: hasProviders ? _openSwipeDeck : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: hasProviders ? Colors.white : Colors.grey[200],
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(hasProviders ? 0.12 : 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: hasProviders
                  ? AppColors.mainAppPrimary.withOpacity(0.3)
                  : Colors.grey[300]!,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.swipe,
                size: 18,
                color: hasProviders ? AppColors.mainAppPrimary : Colors.grey[400],
              ),
              const SizedBox(width: 6),
              Text(
                AppLocalizations.of(context)!.swipeFilterButton,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: hasProviders ? AppColors.mainAppPrimary : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeActiveChip() {
    final count = _swipeState.likedProviderIds.length;
    return Positioned(
      top: 80,
      left: 16,
      child: GestureDetector(
        onTap: _onSwipeReset,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.mainAppPrimary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.mainAppPrimary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.filter_alt, size: 16, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                '$count ${AppLocalizations.of(context)!.swipeFilterActive}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.close, size: 14, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  void _openSwipeDeck() {
    setState(() {
      _selectedProviderId = null;
      _swipeState = _swipeState.copyWith(
        isEnabled: true,
        isSessionActive: true,
      );
    });
  }

  void _onSwipeDecision(String providerId, bool liked) {
    setState(() {
      if (liked) {
        _swipeState = _swipeState.copyWith(
          likedProviderIds: {..._swipeState.likedProviderIds, providerId},
        );
      } else {
        _swipeState = _swipeState.copyWith(
          dislikedProviderIds: {..._swipeState.dislikedProviderIds, providerId},
        );
      }
    });

    // Update markers live
    _createMarkers();

    // Animate camera to next unswiped provider
    final remaining = _mappedProviders.where((p) =>
        !_swipeState.likedProviderIds.contains(p.id) &&
        !_swipeState.dislikedProviderIds.contains(p.id)).toList();
    if (remaining.isNotEmpty) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(remaining.first.position),
      );
    }
  }

  void _onSwipeDone() {
    setState(() {
      _swipeState = _swipeState.copyWith(
        isSessionActive: false,
      );
    });
    _createMarkers();
  }

  void _onSwipeReset() {
    setState(() {
      _swipeState = _swipeState.reset();
    });
    _createMarkers();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
