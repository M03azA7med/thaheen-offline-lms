import 'package:thaheen_assessment/data/datasources/local/courses_local_data_source.dart';
import 'package:thaheen_assessment/domain/entities/course.dart';
import 'package:thaheen_assessment/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CoursesLocalDataSource dataSource;

  CourseRepositoryImpl({required this.dataSource});

  @override
  Future<List<Course>> getCourses() async {
    return await dataSource.getCourses();
  }

  @override
  Future<Course> getCourseDetails(String courseId) async {
    return await dataSource.getCourseDetails(courseId);
  }
}
