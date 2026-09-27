import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thaheen_assessment/core/constants/app_strings.dart';
import 'package:thaheen_assessment/core/theme/app_colors.dart';
import 'package:thaheen_assessment/domain/entities/lesson.dart';

class NextLessonButton extends StatelessWidget {
  final String courseId;
  final Lesson? nextLesson;
  final bool isCompleted;
  final bool isCourseCompleted;

  const NextLessonButton({
    super.key,
    required this.courseId,
    required this.nextLesson,
    required this.isCompleted,
    required this.isCourseCompleted,
  });

  @override
  Widget build(BuildContext context) {
    if (!isCompleted) {
      return const SizedBox.shrink();
    }

    if (isCourseCompleted || nextLesson == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.statusCompleted.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.statusCompleted.withAlpha(50)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.emoji_events_rounded,
              color: AppColors.statusCompleted,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    AppStrings.courseCompletedTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.statusCompleted,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    AppStrings.courseCompletedMessage,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          onPressed: () {
            context.pushReplacement('/course/$courseId/lesson/${nextLesson!.id}');
          },
          icon: const Icon(Icons.skip_next_rounded, size: 22),
          label: Text(
            '${AppStrings.nextLesson}: ${nextLesson!.title}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
