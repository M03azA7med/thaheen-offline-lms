import 'package:thaheen_assessment/core/utils/progress_utils.dart';
import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';

class IsLessonUnlocked {
  bool call({
    required int lessonIndex,
    required List<LessonProgress> progress,
  }) {
    return ProgressUtils.isLessonUnlocked(
      lessonIndex: lessonIndex,
      progressList: progress,
    );
  }
}
