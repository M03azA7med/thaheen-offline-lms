import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thaheen_assessment/core/constants/app_strings.dart';
import 'package:thaheen_assessment/core/theme/app_colors.dart';
import 'package:thaheen_assessment/core/utils/progress_utils.dart';
import 'package:thaheen_assessment/domain/entities/course.dart';
import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';
import 'course_progress_indicator.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final List<LessonProgress> progressList;

  const CourseCard({
    super.key,
    required this.course,
    required this.progressList,
  });

  @override
  Widget build(BuildContext context) {
    final overallProgress = ProgressUtils.calculateCourseProgress(progressList);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          context.push('/course/${course.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 90,
                  height: 90,
                  color: AppColors.primary.withAlpha(30),
                  child: Image.asset(
                    course.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.primary.withAlpha(40),
                        child: const Icon(
                          Icons.school_rounded,
                          color: AppColors.primary,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Course Metadata & Progress
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.instructor,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.play_lesson_outlined,
                          size: 16,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${course.totalLessons} ${AppStrings.lessonsCount}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CourseProgressIndicator(
                      progress: overallProgress,
                      height: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
