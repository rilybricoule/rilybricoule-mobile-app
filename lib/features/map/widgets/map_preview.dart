import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPreview extends StatelessWidget {
  final LatLng position;
  final double height;
  final double borderRadius;
  final bool interactive;
  final VoidCallback? onTap;
  final String? markerTitle;

  const MapPreview({
    super.key,
    required this.position,
    this.height = 200,
    this.borderRadius = 12,
    this.interactive = false,
    this.onTap,
    this.markerTitle,
  });

  @override
  Widget build(BuildContext context) {
    final marker = Marker(
      markerId: const MarkerId('preview'),
      position: position,
      infoWindow: markerTitle != null
          ? InfoWindow(title: markerTitle)
          : InfoWindow.noText,
    );

    Widget mapWidget = GoogleMap(
      initialCameraPosition: CameraPosition(
        target: position,
        zoom: 15,
      ),
      markers: {marker},
      zoomControlsEnabled: false,
      scrollGesturesEnabled: interactive,
      zoomGesturesEnabled: interactive,
      tiltGesturesEnabled: false,
      rotateGesturesEnabled: false,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
    );

    if (onTap != null && !interactive) {
      mapWidget = GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(child: mapWidget),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        child: mapWidget,
      ),
    );
  }
}
