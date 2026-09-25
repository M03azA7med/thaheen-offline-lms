import 'package:thaheen_assessment/data/datasources/local/progress_local_data_source.dart';
import 'package:thaheen_assessment/data/models/lesson_progress_model.dart';
import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';
import 'package:thaheen_assessment/domain/repositories/progress_repository.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressLocalDataSource dataSource;

  ProgressRepositoryImpl({required this.dataSource});

  @override
  Future<LessonProgress?> getLessonProgress(String lessonId) async {
    return await dataSource.getLessonProgress(lessonId);
  }

  @override
  Future<void> saveLessonProgress(LessonProgress progress) async {
    final model = LessonProgressModel.fromEntity(progress);
    await dataSource.saveLessonProgress(model);
  }

  @override
  Future<Map<String, LessonProgress>> getAllProgress() async {
    final modelsMap = await dataSource.getAllProgress();
    return modelsMap.cast<String, LessonProgress>();
  }

  @override
  Future<String?> getLastWatchedLessonId() async {
    return await dataSource.getLastWatchedLessonId();
  }

  @override
  Future<void> saveLastWatchedLesson(String courseId, String lessonId) async {
    await dataSource.saveLastWatchedLesson(courseId, lessonId);
  }

  @override
  Future<double> getPlaybackSpeed() async {
    return await dataSource.getPlaybackSpeed();
  }

  @override
  Future<void> savePlaybackSpeed(double speed) async {
    await dataSource.savePlaybackSpeed(speed);
  }
}
