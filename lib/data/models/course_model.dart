import 'package:thaheen_assessment/domain/entities/course.dart';
import 'section_model.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.instructor,
    required super.thumbnail,
    required super.sections,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final rawSections = json['sections'] as List<dynamic>? ?? [];
    final sections = rawSections
        .map((s) => SectionModel.fromJson(s as Map<String, dynamic>))
        .toList();

    return CourseModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      instructor: json['instructor'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      sections: sections,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'instructor': instructor,
      'thumbnail': thumbnail,
      'sections': sections.map((s) => SectionModel.fromEntity(s).toJson()).toList(),
    };
  }

  factory CourseModel.fromEntity(Course course) {
    return CourseModel(
      id: course.id,
      title: course.title,
      instructor: course.instructor,
      thumbnail: course.thumbnail,
      sections: course.sections,
    );
  }
}
