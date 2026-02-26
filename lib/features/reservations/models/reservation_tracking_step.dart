import 'package:flutter/material.dart';

enum TrackingStepState { done, active, pending }

class ReservationTrackingStep {
  final String title;
  final String subtitle;
  final IconData icon;
  final TrackingStepState state;
  final String? timeLabel;

  ReservationTrackingStep({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.state,
    this.timeLabel,
  });
}
