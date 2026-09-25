import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';
import 'package:thaheen_assessment/domain/repositories/progress_repository.dart';

class SaveLessonProgress {
  final ProgressRepository repository;

  SaveLessonProgress(this.repository);

  Future<void> call(LessonProgress progress) async {
    await repository.saveLessonProgress(progress);
  }
}
