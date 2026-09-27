import 'package:flutter/material.dart';
import 'package:thaheen_assessment/core/theme/app_colors.dart';

class CourseProgressIndicator extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final bool showPercentage;

  const CourseProgressIndicator({
    super.key,
    required this.progress,
    this.height = 8.0,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showPercentage) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'التقدم',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: height,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 1.0 ? AppColors.statusCompleted : AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
