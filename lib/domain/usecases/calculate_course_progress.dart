import 'package:thaheen_assessment/core/utils/progress_utils.dart';
import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';

class CalculateCourseProgress {
  double call(List<LessonProgress> lessons) {
    return ProgressUtils.calculateCourseProgress(lessons);
  }
}
