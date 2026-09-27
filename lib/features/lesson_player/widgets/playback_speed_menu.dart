import 'package:flutter/material.dart';
import 'package:thaheen_assessment/core/constants/app_constants.dart';
import 'package:thaheen_assessment/core/constants/app_strings.dart';
import 'package:thaheen_assessment/core/theme/app_colors.dart';

class PlaybackSpeedMenu extends StatelessWidget {
  final double currentSpeed;
  final ValueChanged<double> onSpeedSelected;

  const PlaybackSpeedMenu({
    super.key,
    required this.currentSpeed,
    required this.onSpeedSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<double>(
      initialValue: currentSpeed,
      onSelected: onSpeedSelected,
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.speed_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              '${currentSpeed}x',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
      itemBuilder: (context) {
        return AppConstants.playbackSpeeds.map((speed) {
          final isSelected = speed == currentSpeed;
          return PopupMenuItem<double>(
            value: speed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppStrings.speed}: ${speed}x',
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_rounded, color: AppColors.primary, size: 18),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
