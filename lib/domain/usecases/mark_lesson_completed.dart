import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';
import 'package:thaheen_assessment/domain/repositories/progress_repository.dart';

class MarkLessonCompleted {
  final ProgressRepository repository;

  MarkLessonCompleted(this.repository);

  Future<void> call({
    required String lessonId,
    required int positionSeconds,
  }) async {
    final updated = LessonProgress(
      lessonId: lessonId,
      positionSeconds: positionSeconds,
      completed: true,
      lastWatchedAt: DateTime.now(),
    );
    await repository.saveLessonProgress(updated);
  }
}
