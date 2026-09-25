import 'package:thaheen_assessment/domain/entities/section.dart';
import 'lesson_model.dart';

class SectionModel extends Section {
  const SectionModel({
    required super.id,
    required super.title,
    required super.lessons,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    final rawLessons = json['lessons'] as List<dynamic>? ?? [];
    final lessons = rawLessons
        .map((l) => LessonModel.fromJson(l as Map<String, dynamic>))
        .toList();

    return SectionModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      lessons: lessons,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lessons': lessons.map((l) => LessonModel.fromEntity(l).toJson()).toList(),
    };
  }

  factory SectionModel.fromEntity(Section section) {
    return SectionModel(
      id: section.id,
      title: section.title,
      lessons: section.lessons,
    );
  }
}
