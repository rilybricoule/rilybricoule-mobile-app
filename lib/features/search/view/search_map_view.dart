import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../models/provider_location.dart';
import '../widgets/provider_preview_card.dart';
import '../widgets/provider_price_marker.dart';

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

  final List<ProviderLocation> _providers = [
    ProviderLocation(
      id: '1',
      name: 'Ahmed El Mansouri',
      category: 'Bricoleur Expert',
      imageUrl: 'assets/images/provider.png',
      rating: 4.9,
      reviewCount: 42,
      distance: 0.8,
      price: '150 MAD',
      position: const LatLng(33.5731, -7.5898),
      isVerified: true,
    ),
    ProviderLocation(
      id: '2',
      name: 'Yassine Amrani',
      category: 'Plombier',
      imageUrl: 'assets/images/provider.png',
      rating: 4.7,
      reviewCount: 38,
      distance: 1.2,
      price: '220 MAD',
      position: const LatLng(33.5850, -7.6050),
      isVerified: true,
    ),
    ProviderLocation(
      id: '3',
      name: 'Omar Hassan',
      category: 'Électricien',
      imageUrl: 'assets/images/provider.png',
      rating: 4.8,
      reviewCount: 56,
      distance: 1.5,
      price: '180 MAD',
      position: const LatLng(33.5650, -7.5750),
      isVerified: true,
    ),
    ProviderLocation(
      id: '4',
      name: 'Karim Benjelloun',
      category: 'Menuisier',
      imageUrl: 'assets/images/provider.png',
      rating: 4.6,
      reviewCount: 29,
      distance: 2.1,
      price: '305 MAD',
      position: const LatLng(33.5800, -7.5700),
      isVerified: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  Future<void> _createMarkers() async {
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
    setState(() {
      _selectedProviderId = providerId;
    });
    await _createMarkers();
  }

  void _recenterMap() {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        const LatLng(33.5731, -7.5898),
        13,
      ),
    );
  }

  ProviderLocation? get _selectedProvider {
    if (_selectedProviderId == null) return null;
    return _providers.firstWhere((p) => p.id == _selectedProviderId);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(33.5731, -7.5898),
            zoom: 13,
          ),
          markers: _markers,
          onMapCreated: (controller) => _mapController = controller,
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
                        'Rechercher un service...',
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
                  'Afficher la liste',
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
