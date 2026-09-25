import 'package:flutter_test/flutter_test.dart';
import 'package:thaheen_assessment/core/utils/progress_utils.dart';
import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';

void main() {
  group('Sequential Lesson Unlock Tests', () {
    final List<LessonProgress> progressList = const [
      LessonProgress(lessonId: 'l1', positionSeconds: 100, completed: true),
      LessonProgress(lessonId: 'l2', positionSeconds: 30, completed: false),
      LessonProgress(lessonId: 'l3', positionSeconds: 0, completed: false),
      LessonProgress(lessonId: 'l4', positionSeconds: 0, completed: false),
    ];

    test('First lesson is ALWAYS unlocked', () {
      final isUnlocked = ProgressUtils.isLessonUnlocked(
        lessonIndex: 0,
        progressList: progressList,
      );
      expect(isUnlocked, isTrue);
    });

    test('Second lesson is unlocked because previous (l1) is completed', () {
      final isUnlocked = ProgressUtils.isLessonUnlocked(
        lessonIndex: 1,
        progressList: progressList,
      );
      expect(isUnlocked, isTrue);
    });

    test('Third lesson is locked because previous (l2) is NOT completed', () {
      final isUnlocked = ProgressUtils.isLessonUnlocked(
        lessonIndex: 2,
        progressList: progressList,
      );
      expect(isUnlocked, isFalse);
    });

    test('Fourth lesson is locked because previous (l3) is NOT completed', () {
      final isUnlocked = ProgressUtils.isLessonUnlocked(
        lessonIndex: 3,
        progressList: progressList,
      );
      expect(isUnlocked, isFalse);
    });
  });
}
