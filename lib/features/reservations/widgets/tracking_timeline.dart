import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../models/reservation_tracking_step.dart';

class TrackingTimeline extends StatelessWidget {
  final List<ReservationTrackingStep> steps;

  const TrackingTimeline({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: step.state == TrackingStepState.done || step.state == TrackingStepState.active
                        ? AppColors.mainAppPrimary
                        : Colors.grey[200],
                    shape: BoxShape.circle,
                    border: step.state == TrackingStepState.active
                        ? Border.all(color: AppColors.mainAppPrimary.withOpacity(0.3), width: 4)
                        : null,
                  ),
                  child: Icon(
                    step.icon,
                    color: step.state == TrackingStepState.done || step.state == TrackingStepState.active
                        ? Colors.white
                        : Colors.grey[400],
                    size: 24,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 60,
                    color: step.state == TrackingStepState.done
                        ? AppColors.mainAppPrimary
                        : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: step.state != TrackingStepState.pending
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step.subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
