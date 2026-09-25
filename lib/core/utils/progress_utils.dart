import 'package:thaheen_assessment/core/constants/app_constants.dart';
import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';

class ProgressUtils {
  /// Check if lesson auto-completes (completion threshold default 90%)
  static bool isLessonCompleted({
    required int positionSeconds,
    required int durationSeconds,
  }) {
    if (durationSeconds <= 0) return false;
    return (positionSeconds / durationSeconds) >= AppConstants.completionThreshold;
  }

  /// Calculate single lesson progress between 0.0 and 1.0
  static double calculateLessonProgress({
    required int positionSeconds,
    required int durationSeconds,
  }) {
    if (durationSeconds <= 0) return 0.0;
    return (positionSeconds / durationSeconds).clamp(0.0, 1.0);
  }

  /// Calculate overall course completion ratio between 0.0 and 1.0
  static double calculateCourseProgress(List<LessonProgress> progressList) {
    if (progressList.isEmpty) return 0.0;
    final completedCount = progressList.where((p) => p.completed).length;
    return completedCount / progressList.length;
  }

  /// Check if a lesson is unlocked given its index in the FLATTENED lesson list
  static bool isLessonUnlocked({
    required int lessonIndex,
    required List<LessonProgress> progressList,
  }) {
    // First lesson in course is always unlocked
    if (lessonIndex == 0) return true;
    if (lessonIndex < 0 || lessonIndex >= progressList.length) return false;

    // Next lesson is unlocked if previous lesson is completed
    return progressList[lessonIndex - 1].completed;
  }

  /// Format seconds into mm:ss format (e.g. 95 -> "01:35")
  static String formatDuration(int seconds) {
    if (seconds <= 0) return '00:00';
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours;
    if (hours > 0) {
      final hrs = hours.toString().padLeft(2, '0');
      return '$hrs:$minutes:$secs';
    }
    return '$minutes:$secs';
  }
}
