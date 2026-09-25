import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaheen_assessment/core/constants/app_strings.dart';
import 'package:thaheen_assessment/core/router/app_router.dart';
import 'package:thaheen_assessment/core/theme/app_colors.dart';
import 'package:thaheen_assessment/data/datasources/local/courses_local_data_source.dart';
import 'package:thaheen_assessment/data/datasources/local/progress_local_data_source.dart';
import 'package:thaheen_assessment/data/repositories/course_repository_impl.dart';
import 'package:thaheen_assessment/data/repositories/progress_repository_impl.dart';

import 'core/app/presention/view/thaheen_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Custom Error Widget builder to catch and render graceful UI error screens
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: AppColors.error,
              ),
              SizedBox(height: 16),
              Text(
                AppStrings.loadCoursesError,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  };

  // Manual Dependency Injection / Composition Root
  final sharedPreferences = await SharedPreferences.getInstance();

  final coursesDataSource = CoursesLocalDataSourceImpl();
  final progressDataSource = ProgressLocalDataSourceImpl(
    sharedPreferences: sharedPreferences,
  );

  final courseRepository = CourseRepositoryImpl(dataSource: coursesDataSource);
  final progressRepository = ProgressRepositoryImpl(
    dataSource: progressDataSource,
  );

  final appRouter = AppRouter(
    courseRepository: courseRepository,
    progressRepository: progressRepository,
  );

  runApp(ThaheenApp(appRouter: appRouter));
}
