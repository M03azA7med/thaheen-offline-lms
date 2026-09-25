import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';
import 'package:thaheen_assessment/domain/repositories/progress_repository.dart';

class GetLessonProgress {
  final ProgressRepository repository;

  GetLessonProgress(this.repository);

  Future<LessonProgress?> call(String lessonId) async {
    return await repository.getLessonProgress(lessonId);
  }
}
