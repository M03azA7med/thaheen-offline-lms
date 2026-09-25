import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';

abstract class ProgressRepository {
  Future<LessonProgress?> getLessonProgress(String lessonId);
  Future<void> saveLessonProgress(LessonProgress progress);
  Future<Map<String, LessonProgress>> getAllProgress();
  Future<String?> getLastWatchedLessonId();
  Future<void> saveLastWatchedLesson(String courseId, String lessonId);
  Future<double> getPlaybackSpeed();
  Future<void> savePlaybackSpeed(double speed);
}
