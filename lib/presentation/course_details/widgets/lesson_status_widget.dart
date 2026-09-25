import 'package:flutter/material.dart';
import 'package:thaheen_assessment/core/constants/app_strings.dart';
import 'package:thaheen_assessment/core/theme/app_colors.dart';

enum LessonStatus { notStarted, inProgress, completed, locked }

class LessonStatusWidget extends StatelessWidget {
  final LessonStatus status;

  const LessonStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;
    String text;

    switch (status) {
      case LessonStatus.completed:
        bg = AppColors.statusCompleted.withAlpha(30);
        fg = AppColors.statusCompleted;
        icon = Icons.check_circle_rounded;
        text = AppStrings.statusCompleted;
        break;
      case LessonStatus.inProgress:
        bg = AppColors.statusInProgress.withAlpha(30);
        fg = AppColors.statusInProgress;
        icon = Icons.play_circle_fill_rounded;
        text = AppStrings.statusInProgress;
        break;
      case LessonStatus.notStarted:
        bg = AppColors.statusNotStarted.withAlpha(20);
        fg = AppColors.statusNotStarted;
        icon = Icons.play_circle_outline_rounded;
        text = AppStrings.statusNotStarted;
        break;
      case LessonStatus.locked:
        bg = AppColors.statusLocked.withAlpha(20);
        fg = AppColors.statusLocked;
        icon = Icons.lock_outline_rounded;
        text = AppStrings.statusLocked;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
