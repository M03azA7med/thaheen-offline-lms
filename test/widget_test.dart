import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaheen_assessment/core/app/presention/view/thaheen_app.dart';
import 'package:thaheen_assessment/core/router/app_router.dart';
import 'package:thaheen_assessment/data/datasources/local/courses_local_data_source.dart';
import 'package:thaheen_assessment/data/datasources/local/progress_local_data_source.dart';
import 'package:thaheen_assessment/data/repositories/course_repository_impl.dart';
import 'package:thaheen_assessment/data/repositories/progress_repository_impl.dart';

void main() {
  testWidgets('ThaheenApp smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final coursesDataSource = CoursesLocalDataSourceImpl();
    final progressDataSource = ProgressLocalDataSourceImpl(sharedPreferences: prefs);

    final courseRepository = CourseRepositoryImpl(dataSource: coursesDataSource);
    final progressRepository = ProgressRepositoryImpl(dataSource: progressDataSource);

    final appRouter = AppRouter(
      courseRepository: courseRepository,
      progressRepository: progressRepository,
    );

    await tester.pumpWidget(ThaheenApp(appRouter: appRouter));
    expect(find.byType(ThaheenApp), findsOneWidget);
  });
}
