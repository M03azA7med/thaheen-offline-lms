import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thaheen_assessment/domain/repositories/course_repository.dart';
import 'package:thaheen_assessment/domain/repositories/progress_repository.dart';
import 'package:thaheen_assessment/domain/usecases/get_course_details.dart';
import 'package:thaheen_assessment/domain/usecases/get_courses.dart';
import 'package:thaheen_assessment/presentation/course_details/cubit/course_details_cubit.dart';
import 'package:thaheen_assessment/presentation/course_details/pages/course_details_page.dart';
import 'package:thaheen_assessment/presentation/courses/cubit/courses_cubit.dart';
import 'package:thaheen_assessment/presentation/courses/pages/courses_page.dart';
import 'package:thaheen_assessment/presentation/lesson_player/cubit/lesson_player_cubit.dart';
import 'package:thaheen_assessment/presentation/lesson_player/pages/lesson_player_page.dart';

class AppRouter {
  final CourseRepository courseRepository;
  final ProgressRepository progressRepository;

  AppRouter({
    required this.courseRepository,
    required this.progressRepository,
  });

  late final GoRouter router = GoRouter(
    initialLocation: '/courses',
    routes: [
      GoRoute(
        path: '/courses',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => CoursesCubit(
              getCourses: GetCourses(courseRepository),
              progressRepository: progressRepository,
            ),
            child: const CoursesPage(),
          );
        },
      ),
      GoRoute(
        path: '/course/:courseId',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId'] ?? '';
          return BlocProvider(
            create: (context) => CourseDetailsCubit(
              getCourseDetails: GetCourseDetails(courseRepository),
              progressRepository: progressRepository,
            ),
            child: CourseDetailsPage(courseId: courseId),
          );
        },
      ),
      GoRoute(
        path: '/course/:courseId/lesson/:lessonId',
        builder: (context, state) {
          final courseId = state.pathParameters['courseId'] ?? '';
          final lessonId = state.pathParameters['lessonId'] ?? '';
          return BlocProvider(
            create: (context) => LessonPlayerCubit(
              getCourseDetails: GetCourseDetails(courseRepository),
              progressRepository: progressRepository,
            ),
            child: LessonPlayerPage(
              courseId: courseId,
              lessonId: lessonId,
            ),
          );
        },
      ),
    ],
  );
}
