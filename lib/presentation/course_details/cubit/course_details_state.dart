import 'package:equatable/equatable.dart';
import 'package:thaheen_assessment/domain/entities/course.dart';
import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';

abstract class CourseDetailsState extends Equatable {
  const CourseDetailsState();

  @override
  List<Object?> get props => [];
}

class CourseDetailsInitial extends CourseDetailsState {}

class CourseDetailsLoading extends CourseDetailsState {}

class CourseDetailsLoaded extends CourseDetailsState {
  final Course course;
  final List<LessonProgress> progressList;
  final Map<String, bool> unlockedLessons; // lessonId -> unlocked boolean
  final Map<String, LessonProgress> progressMap; // lessonId -> LessonProgress
  final double overallProgress;

  const CourseDetailsLoaded({
    required this.course,
    required this.progressList,
    required this.unlockedLessons,
    required this.progressMap,
    required this.overallProgress,
  });

  @override
  List<Object?> get props => [
        course,
        progressList,
        unlockedLessons,
        progressMap,
        overallProgress,
      ];
}

class CourseDetailsError extends CourseDetailsState {
  final String message;

  const CourseDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
