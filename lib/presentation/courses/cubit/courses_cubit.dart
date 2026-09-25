import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_assessment/domain/entities/course.dart';
import 'package:thaheen_assessment/domain/entities/lesson.dart';
import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';
import 'package:thaheen_assessment/domain/repositories/progress_repository.dart';
import 'package:thaheen_assessment/domain/usecases/get_courses.dart';
import 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  final GetCourses getCourses;
  final ProgressRepository progressRepository;

  CoursesCubit({
    required this.getCourses,
    required this.progressRepository,
  }) : super(CoursesInitial());

  Future<void> loadCourses() async {
    emit(CoursesLoading());
    try {
      final courses = await getCourses();
      if (courses.isEmpty) {
        emit(CoursesEmpty());
        return;
      }

      final Map<String, List<LessonProgress>> courseProgresses = {};
      final allProgressMap = await progressRepository.getAllProgress();
      final lastWatchedLessonId = await progressRepository.getLastWatchedLessonId();

      Lesson? continueLesson;
      Course? continueCourse;
      LessonProgress? continueProgress;
      DateTime? newestTime;

      for (final course in courses) {
        final List<LessonProgress> lessonProgressList = [];
        final flattened = course.flattenedLessons;

        for (final lesson in flattened) {
          final progress = allProgressMap[lesson.id] ??
              LessonProgress(
                lessonId: lesson.id,
                positionSeconds: 0,
                completed: false,
              );
          lessonProgressList.add(progress);

          // Check for Continue Watching candidates
          if (!progress.completed) {
            bool isCandidate = false;
            if (lastWatchedLessonId != null && lesson.id == lastWatchedLessonId) {
              isCandidate = true;
            } else if (progress.positionSeconds > 0) {
              if (newestTime == null ||
                  (progress.lastWatchedAt != null && progress.lastWatchedAt!.isAfter(newestTime))) {
                isCandidate = true;
              }
            }

            if (isCandidate) {
              continueLesson = lesson;
              continueCourse = course;
              continueProgress = progress;
              if (progress.lastWatchedAt != null) {
                newestTime = progress.lastWatchedAt;
              }
            }
          }
        }

        courseProgresses[course.id] = lessonProgressList;
      }

      emit(CoursesLoaded(
        courses: courses,
        courseProgresses: courseProgresses,
        continueWatchingLesson: continueLesson,
        continueWatchingCourse: continueCourse,
        continueWatchingProgress: continueProgress,
      ));
    } catch (e) {
      emit(CoursesError('تعذر تحميل بيانات الدورة. يرجى المحاولة مرة أخرى.'));
    }
  }
}
