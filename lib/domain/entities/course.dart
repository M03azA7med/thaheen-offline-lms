import 'package:equatable/equatable.dart';
import 'lesson.dart';
import 'section.dart';

class Course extends Equatable {
  final String id;
  final String title;
  final String instructor;
  final String thumbnail;
  final List<Section> sections;

  const Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.thumbnail,
    required this.sections,
  });

  /// Helper to get all lessons flattened across all sections in strict sequential order
  List<Lesson> get flattenedLessons {
    return sections.expand((section) => section.lessons).toList();
  }

  /// Helper to get total number of lessons in course
  int get totalLessons => flattenedLessons.length;

  @override
  List<Object?> get props => [id, title, instructor, thumbnail, sections];
}
