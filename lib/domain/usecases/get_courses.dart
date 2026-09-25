import 'package:thaheen_assessment/domain/entities/course.dart';
import 'package:thaheen_assessment/domain/repositories/course_repository.dart';

class GetCourses {
  final CourseRepository repository;

  GetCourses(this.repository);

  Future<List<Course>> call() async {
    return await repository.getCourses();
  }
}
