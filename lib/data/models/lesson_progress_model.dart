import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';

class LessonProgressModel extends LessonProgress {
  const LessonProgressModel({
    required super.lessonId,
    required super.positionSeconds,
    required super.completed,
    super.lastWatchedAt,
  });

  factory LessonProgressModel.fromJson(Map<String, dynamic> json) {
    return LessonProgressModel(
      lessonId: json['lessonId'] as String? ?? json['id'] as String? ?? '',
      positionSeconds: (json['positionSeconds'] as num?)?.toInt() ??
          (json['position'] as num?)?.toInt() ??
          0,
      completed: json['completed'] as bool? ?? false,
      lastWatchedAt: json['lastWatchedAt'] != null
          ? DateTime.tryParse(json['lastWatchedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'positionSeconds': positionSeconds,
      'completed': completed,
      if (lastWatchedAt != null) 'lastWatchedAt': lastWatchedAt!.toIso8601String(),
    };
  }

  factory LessonProgressModel.fromEntity(LessonProgress progress) {
    return LessonProgressModel(
      lessonId: progress.lessonId,
      positionSeconds: progress.positionSeconds,
      completed: progress.completed,
      lastWatchedAt: progress.lastWatchedAt,
    );
  }
}
