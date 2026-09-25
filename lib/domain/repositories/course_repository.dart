import 'package:thaheen_assessment/domain/entities/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses();
  Future<Course> getCourseDetails(String courseId);
}
