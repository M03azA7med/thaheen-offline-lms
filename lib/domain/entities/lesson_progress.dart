import 'package:equatable/equatable.dart';

class LessonProgress extends Equatable {
  final String lessonId;
  final int positionSeconds;
  final bool completed;
  final DateTime? lastWatchedAt;

  const LessonProgress({
    required this.lessonId,
    required this.positionSeconds,
    required this.completed,
    this.lastWatchedAt,
  });

  LessonProgress copyWith({
    String? lessonId,
    int? positionSeconds,
    bool? completed,
    DateTime? lastWatchedAt,
  }) {
    return LessonProgress(
      lessonId: lessonId ?? this.lessonId,
      positionSeconds: positionSeconds ?? this.positionSeconds,
      completed: completed ?? this.completed,
      lastWatchedAt: lastWatchedAt ?? this.lastWatchedAt,
    );
  }

  @override
  List<Object?> get props => [lessonId, positionSeconds, completed, lastWatchedAt];
}
