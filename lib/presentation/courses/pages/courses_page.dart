import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_assessment/core/constants/app_strings.dart';
import 'package:thaheen_assessment/core/theme/app_colors.dart';
import 'package:thaheen_assessment/presentation/courses/cubit/courses_cubit.dart';
import 'package:thaheen_assessment/presentation/courses/cubit/courses_state.dart';
import 'package:thaheen_assessment/presentation/courses/widgets/continue_watching_card.dart';
import 'package:thaheen_assessment/presentation/courses/widgets/course_card.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  void initState() {
    super.initState();
    context.read<CoursesCubit>().loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
      ),
      body: BlocBuilder<CoursesCubit, CoursesState>(
        builder: (context, state) {
          if (state is CoursesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is CoursesEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.menu_book_outlined,
                      size: 72,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      AppStrings.emptyCourses,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<CoursesCubit>().loadCourses(),
                      child: const Text(AppStrings.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CoursesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 72,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<CoursesCubit>().loadCourses(),
                      child: const Text(AppStrings.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CoursesLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<CoursesCubit>().loadCourses(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Continue Watching Section
                  if (state.continueWatchingLesson != null &&
                      state.continueWatchingCourse != null &&
                      state.continueWatchingProgress != null) ...[
                    ContinueWatchingCard(
                      course: state.continueWatchingCourse!,
                      lesson: state.continueWatchingLesson!,
                      progress: state.continueWatchingProgress!,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Available Courses Section Header
                  const Text(
                    AppStrings.availableCourses,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Course List
                  ...state.courses.map((course) {
                    final progressList = state.courseProgresses[course.id] ?? [];
                    return CourseCard(
                      course: course,
                      progressList: progressList,
                    );
                  }),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
