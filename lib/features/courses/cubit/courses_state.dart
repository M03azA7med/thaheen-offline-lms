import 'package:equatable/equatable.dart';
import 'package:thaheen_assessment/domain/entities/course.dart';
import 'package:thaheen_assessment/domain/entities/lesson.dart';
import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';

abstract class CoursesState extends Equatable {
  const CoursesState();

  @override
  List<Object?> get props => [];
}

class CoursesInitial extends CoursesState {}

class CoursesLoading extends CoursesState {}

class CoursesLoaded extends CoursesState {
  final List<Course> courses;
  final Map<String, List<LessonProgress>> courseProgresses; // courseId -> progress list
  final Lesson? continueWatchingLesson;
  final Course? continueWatchingCourse;
  final LessonProgress? continueWatchingProgress;

  const CoursesLoaded({
    required this.courses,
    required this.courseProgresses,
    this.continueWatchingLesson,
    this.continueWatchingCourse,
    this.continueWatchingProgress,
  });

  @override
  List<Object?> get props => [
        courses,
        courseProgresses,
        continueWatchingLesson,
        continueWatchingCourse,
        continueWatchingProgress,
      ];
}

class CoursesEmpty extends CoursesState {}

class CoursesError extends CoursesState {
  final String message;

  const CoursesError(this.message);

  @override
  List<Object?> get props => [message];
}
