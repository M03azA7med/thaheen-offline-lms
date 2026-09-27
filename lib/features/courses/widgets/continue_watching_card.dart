import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thaheen_assessment/core/constants/app_strings.dart';
import 'package:thaheen_assessment/core/theme/app_colors.dart';
import 'package:thaheen_assessment/core/utils/progress_utils.dart';
import 'package:thaheen_assessment/domain/entities/course.dart';
import 'package:thaheen_assessment/domain/entities/lesson.dart';
import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';
import 'course_progress_indicator.dart';

class ContinueWatchingCard extends StatelessWidget {
  final Course course;
  final Lesson lesson;
  final LessonProgress progress;

  const ContinueWatchingCard({
    super.key,
    required this.course,
    required this.lesson,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final lessonRatio = ProgressUtils.calculateLessonProgress(
      positionSeconds: progress.positionSeconds,
      durationSeconds: lesson.durationSec,
    );

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withAlpha(20),
              AppColors.surface,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.play_circle_fill,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  AppStrings.continueWatching,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              lesson.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            CourseProgressIndicator(
              progress: lessonRatio,
              height: 6,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push('/course/${course.id}/lesson/${lesson.id}');
                },
                icon: const Icon(Icons.play_arrow_rounded, size: 20),
                label: const Text(AppStrings.continueButton),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
