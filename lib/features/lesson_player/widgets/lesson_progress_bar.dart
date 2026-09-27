import 'package:flutter/material.dart';
import 'package:thaheen_assessment/core/theme/app_colors.dart';
import 'package:thaheen_assessment/core/utils/progress_utils.dart';

class LessonProgressBar extends StatelessWidget {
  final Duration currentPosition;
  final Duration totalDuration;
  final ValueChanged<Duration> onSeek;

  const LessonProgressBar({
    super.key,
    required this.currentPosition,
    required this.totalDuration,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    final maxMs = totalDuration.inMilliseconds > 0
        ? totalDuration.inMilliseconds.toDouble()
        : 1.0;
    final currentMs = currentPosition.inMilliseconds
        .toDouble()
        .clamp(0.0, maxMs);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ProgressUtils.formatDuration(currentPosition.inSeconds),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              ProgressUtils.formatDuration(totalDuration.inSeconds),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            activeTrackColor: AppColors.primaryLight,
            inactiveTrackColor: Colors.white24,
            thumbColor: AppColors.primaryLight,
            overlayColor: AppColors.primaryLight.withAlpha(50),
          ),
          child: Slider(
            value: currentMs,
            min: 0.0,
            max: maxMs,
            onChanged: (value) {
              onSeek(Duration(milliseconds: value.toInt()));
            },
          ),
        ),
      ],
    );
  }
}
