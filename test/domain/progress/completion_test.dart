import 'package:flutter_test/flutter_test.dart';
import 'package:thaheen_assessment/core/utils/progress_utils.dart';

void main() {
  group('Lesson Completion Tests (90% threshold)', () {
    test('89% is NOT completed', () {
      final isCompleted = ProgressUtils.isLessonCompleted(
        positionSeconds: 89,
        durationSeconds: 100,
      );
      expect(isCompleted, isFalse);
    });

    test('90% IS completed', () {
      final isCompleted = ProgressUtils.isLessonCompleted(
        positionSeconds: 90,
        durationSeconds: 100,
      );
      expect(isCompleted, isTrue);
    });

    test('95% IS completed', () {
      final isCompleted = ProgressUtils.isLessonCompleted(
        positionSeconds: 95,
        durationSeconds: 100,
      );
      expect(isCompleted, isTrue);
    });

    test('100% IS completed', () {
      final isCompleted = ProgressUtils.isLessonCompleted(
        positionSeconds: 100,
        durationSeconds: 100,
      );
      expect(isCompleted, isTrue);
    });

    test('Handles 0 duration gracefully without division by zero', () {
      final isCompleted = ProgressUtils.isLessonCompleted(
        positionSeconds: 0,
        durationSeconds: 0,
      );
      expect(isCompleted, isFalse);
    });
  });
}
