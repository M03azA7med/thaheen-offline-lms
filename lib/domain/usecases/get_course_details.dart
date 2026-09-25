import 'package:thaheen_assessment/domain/entities/course.dart';
import 'package:thaheen_assessment/domain/repositories/course_repository.dart';

class GetCourseDetails {
  final CourseRepository repository;

  GetCourseDetails(this.repository);

  Future<Course> call(String courseId) async {
    return await repository.getCourseDetails(courseId);
  }
}
