import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_assessment/core/utils/progress_utils.dart';
import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';
import 'package:thaheen_assessment/domain/repositories/progress_repository.dart';
import 'package:thaheen_assessment/domain/usecases/get_course_details.dart';
import 'course_details_state.dart';

class CourseDetailsCubit extends Cubit<CourseDetailsState> {
  final GetCourseDetails getCourseDetails;
  final ProgressRepository progressRepository;

  CourseDetailsCubit({
    required this.getCourseDetails,
    required this.progressRepository,
  }) : super(CourseDetailsInitial());

  Future<void> loadCourseDetails(String courseId) async {
    emit(CourseDetailsLoading());
    try {
      final course = await getCourseDetails(courseId);
      final flattened = course.flattenedLessons;

      final allProgressMap = await progressRepository.getAllProgress();

      final List<LessonProgress> progressList = [];
      final Map<String, LessonProgress> progressMap = {};
      final Map<String, bool> unlockedMap = {};

      for (int i = 0; i < flattened.length; i++) {
        final lesson = flattened[i];
        final progress = allProgressMap[lesson.id] ??
            LessonProgress(
              lessonId: lesson.id,
              positionSeconds: 0,
              completed: false,
            );
        progressList.add(progress);
        progressMap[lesson.id] = progress;
      }

      // Calculate sequential unlocking across FLATTENED course lesson list
      for (int i = 0; i < flattened.length; i++) {
        final lesson = flattened[i];
        final isUnlocked = ProgressUtils.isLessonUnlocked(
          lessonIndex: i,
          progressList: progressList,
        );
        unlockedMap[lesson.id] = isUnlocked;
      }

      final overallProgress = ProgressUtils.calculateCourseProgress(progressList);

      emit(CourseDetailsLoaded(
        course: course,
        progressList: progressList,
        unlockedLessons: unlockedMap,
        progressMap: progressMap,
        overallProgress: overallProgress,
      ));
    } catch (e) {
      emit(CourseDetailsError('تعذر تحميل بيانات الدورة. يرجى المحاولة مرة أخرى.'));
    }
  }
}
