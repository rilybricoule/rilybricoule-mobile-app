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
import '../repository/providers_repository.dart';
import '../widgets/provider_price_marker.dart';
import '../widgets/provider_preview_card.dart';
import '../../../l10n/app_localizations.dart';

class SearchMapView extends StatefulWidget {
  final Function(VoidCallback) onShowFilters;
  final VoidCallback onSwitchToList;
  final VoidCallback? onSearchTap;

  const SearchMapView({
    super.key,
    required this.onShowFilters,
    required this.onSwitchToList,
    this.onSearchTap,
  });

  @override
  State<SearchMapView> createState() => _SearchMapViewState();
}

class _SearchMapViewState extends State<SearchMapView> {
  GoogleMapController? _mapController;
  String? _selectedProviderId;
  final Set<Marker> _markers = {};
  List<ProviderLocation> _providers = [];
  bool _isLoading = true;
  String? _errorMessage;
  LocationPermissionStatus? _permissionStatus;
  Position? _currentPosition;
  final _locationService = LocationService();
  final _repository = ProvidersRepository();

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final permissionStatus = await _locationService.checkPermission();
    setState(() => _permissionStatus = permissionStatus);

    if (permissionStatus == LocationPermissionStatus.granted) {
      await _loadProviders();
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadProviders() async {
    try {
      final position = await _locationService.getCurrentPosition();
      if (position == null) {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.errorGettingLocation;
          _isLoading = false;
        });
        return;
      }

      setState(() => _currentPosition = position);

      final providers = await _repository.fetchProvidersAround(
        lat: position.latitude,
        lng: position.longitude,
        radiusKm: 10,
      );

      setState(() {
        _providers = providers;
        _isLoading = false;
      });

      if (providers.isNotEmpty) {
        await _createMarkers();
      }

      // Center map on user location
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          13,
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.errorLoadingProviders;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _createMarkers() async {
    _markers.clear();
    for (var provider in _providers) {
      final marker = await _createMarkerFromWidget(
        provider,
        _selectedProviderId == provider.id,
      );
      _markers.add(marker);
    }
    if (mounted) setState(() {});
  }

  Future<Marker> _createMarkerFromWidget(
    ProviderLocation provider,
    bool isSelected,
  ) async {
    final markerWidget = ProviderPriceMarker(
      price: provider.price.split(' ')[0],
      isSelected: isSelected,
      isBusy: provider.status == ProviderStatus.busy,
    );

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = const Size(100, 50);

    final widget = RepaintBoundary(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: markerWidget,
      ),
    );

    final renderObject = RenderRepaintBoundary();
    final pipelineOwner = PipelineOwner()..rootNode = renderObject;
    final buildOwner = BuildOwner(focusManager: FocusManager());

    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: renderObject,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: widget,
      ),
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final image = await renderObject.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    return Marker(
      markerId: MarkerId(provider.id),
      position: provider.position,
      icon: BitmapDescriptor.fromBytes(bytes),
      onTap: () => _onMarkerTapped(provider.id),
    );
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
      return _providers.firstWhere((p) => p.id == _selectedProviderId);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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

    if (_providers.isEmpty) {
      return Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(_currentPosition?.latitude ?? 33.5731, _currentPosition?.longitude ?? -7.5898),
              zoom: 13,
            ),
            onMapCreated: (controller) => _mapController = controller,
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
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(33.5731, -7.5898),
            zoom: 13,
          ),
          markers: _markers,
          onMapCreated: (controller) => _mapController = controller,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),
        _buildSearchBar(),
        _buildMapControls(),
        _buildShowListButton(),
        if (_selectedProvider != null) _buildProviderPreview(),
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
          GestureDetector(
            onTap: () => widget.onShowFilters(() {}),
            child: Container(
              padding: const EdgeInsets.all(12),
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
              child: const Icon(Icons.tune, color: Colors.white, size: 24),
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
      bottom: _selectedProvider != null ? 140 : 32,
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
      child: ProviderPreviewCard(
        provider: _selectedProvider!,
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
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
