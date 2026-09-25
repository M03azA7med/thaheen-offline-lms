import 'package:flutter_test/flutter_test.dart';
import 'package:thaheen_assessment/core/utils/progress_utils.dart';
import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';

void main() {
  group('Course Overall Progress Calculation Tests', () {
    test('2 completed / 4 total lessons = 50% (0.50)', () {
      final progressList = const [
        LessonProgress(lessonId: 'l1', positionSeconds: 100, completed: true),
        LessonProgress(lessonId: 'l2', positionSeconds: 120, completed: true),
        LessonProgress(lessonId: 'l3', positionSeconds: 10, completed: false),
        LessonProgress(lessonId: 'l4', positionSeconds: 0, completed: false),
      ];

      final progress = ProgressUtils.calculateCourseProgress(progressList);
      expect(progress, equals(0.50));
    });

    test('0 lessons returns 0% (0.0) without error or NaN', () {
      final progress = ProgressUtils.calculateCourseProgress([]);
      expect(progress, equals(0.0));
      expect(progress.isNaN, isFalse);
    });

    test('All lessons completed returns 100% (1.0)', () {
      final progressList = const [
        LessonProgress(lessonId: 'l1', positionSeconds: 100, completed: true),
        LessonProgress(lessonId: 'l2', positionSeconds: 120, completed: true),
      ];

      final progress = ProgressUtils.calculateCourseProgress(progressList);
      expect(progress, equals(1.0));
    });
  });
}
