import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thaheen_assessment/core/constants/app_strings.dart';
import 'package:thaheen_assessment/core/theme/app_colors.dart';
import 'package:thaheen_assessment/core/utils/progress_utils.dart';
import 'package:thaheen_assessment/domain/entities/lesson.dart';
import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';
import 'lesson_status_widget.dart';

class LessonTile extends StatelessWidget {
  final String courseId;
  final Lesson lesson;
  final LessonProgress? progress;
  final bool isUnlocked;

  const LessonTile({
    super.key,
    required this.courseId,
    required this.lesson,
    required this.progress,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    LessonStatus status;
    if (!isUnlocked) {
      status = LessonStatus.locked;
    } else if (progress != null && progress!.completed) {
      status = LessonStatus.completed;
    } else if (progress != null && progress!.positionSeconds > 0) {
      status = LessonStatus.inProgress;
    } else {
      status = LessonStatus.notStarted;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.surface : AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked ? AppColors.border : AppColors.border.withAlpha(50),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: () {
          if (!isUnlocked) {
            _showLockedDialog(context);
          } else {
            context.push('/course/$courseId/lesson/${lesson.id}');
          }
        },
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: isUnlocked
              ? AppColors.primary.withAlpha(20)
              : AppColors.statusLocked.withAlpha(20),
          child: Icon(
            !isUnlocked
                ? Icons.lock_rounded
                : (status == LessonStatus.completed
                    ? Icons.check_rounded
                    : Icons.play_arrow_rounded),
            color: isUnlocked ? AppColors.primary : AppColors.textMuted,
            size: 20,
          ),
        ),
        title: Text(
          lesson.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isUnlocked ? AppColors.textPrimary : AppColors.textMuted,
          ),
        ),
        subtitle: Text(
          ProgressUtils.formatDuration(lesson.durationSec),
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: LessonStatusWidget(status: status),
      ),
    );
  }

  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.lock_outline_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text(AppStrings.lessonLockedTitle),
          ],
        ),
        content: const Text(AppStrings.lessonLockedMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}
