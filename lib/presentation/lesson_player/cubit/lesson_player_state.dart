import 'package:equatable/equatable.dart';
import 'package:thaheen_assessment/domain/entities/course.dart';
import 'package:thaheen_assessment/domain/entities/lesson.dart';
import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';

abstract class LessonPlayerState extends Equatable {
  const LessonPlayerState();

  @override
  List<Object?> get props => [];
}

class LessonPlayerInitial extends LessonPlayerState {}

class LessonPlayerLoading extends LessonPlayerState {}

class LessonPlayerReady extends LessonPlayerState {
  final Course course;
  final Lesson lesson;
  final Lesson? nextLesson;
  final LessonProgress progress;
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final double playbackSpeed;
  final bool isCompleted;
  final bool isFullscreen;
  final bool isCourseCompleted;

  const LessonPlayerReady({
    required this.course,
    required this.lesson,
    this.nextLesson,
    required this.progress,
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
    required this.playbackSpeed,
    required this.isCompleted,
    required this.isFullscreen,
    required this.isCourseCompleted,
  });

  LessonPlayerReady copyWith({
    Course? course,
    Lesson? lesson,
    Lesson? nextLesson,
    LessonProgress? progress,
    bool? isPlaying,
    Duration? currentPosition,
    Duration? totalDuration,
    double? playbackSpeed,
    bool? isCompleted,
    bool? isFullscreen,
    bool? isCourseCompleted,
  }) {
    return LessonPlayerReady(
      course: course ?? this.course,
      lesson: lesson ?? this.lesson,
      nextLesson: nextLesson ?? this.nextLesson,
      progress: progress ?? this.progress,
      isPlaying: isPlaying ?? this.isPlaying,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      isCompleted: isCompleted ?? this.isCompleted,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      isCourseCompleted: isCourseCompleted ?? this.isCourseCompleted,
    );
  }

  @override
  List<Object?> get props => [
        course,
        lesson,
        nextLesson,
        progress,
        isPlaying,
        currentPosition,
        totalDuration,
        playbackSpeed,
        isCompleted,
        isFullscreen,
        isCourseCompleted,
      ];
}

class LessonPlayerError extends LessonPlayerState {
  final String message;

  const LessonPlayerError(this.message);

  @override
  List<Object?> get props => [message];
}
