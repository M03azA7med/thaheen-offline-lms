import 'package:flutter/material.dart';
import 'package:thaheen_assessment/core/theme/app_colors.dart';
import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';
import 'package:thaheen_assessment/domain/entities/section.dart';
import 'lesson_tile.dart';

class SectionWidget extends StatelessWidget {
  final String courseId;
  final Section section;
  final Map<String, LessonProgress> progressMap;
  final Map<String, bool> unlockedLessons;

  const SectionWidget({
    super.key,
    required this.courseId,
    required this.section,
    required this.progressMap,
    required this.unlockedLessons,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const Icon(
                Icons.folder_open_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  section.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...section.lessons.map((lesson) {
          final progress = progressMap[lesson.id];
          final isUnlocked = unlockedLessons[lesson.id] ?? false;

          return LessonTile(
            courseId: courseId,
            lesson: lesson,
            progress: progress,
            isUnlocked: isUnlocked,
          );
        }),
        const SizedBox(height: 12),
      ],
    );
  }
}
