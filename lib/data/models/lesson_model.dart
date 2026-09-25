import 'package:thaheen_assessment/domain/entities/lesson.dart';

class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.title,
    required super.durationSec,
    required super.video,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      durationSec: (json['durationSec'] as num?)?.toInt() ?? 0,
      video: json['video'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'durationSec': durationSec,
      'video': video,
    };
  }

  factory LessonModel.fromEntity(Lesson lesson) {
    return LessonModel(
      id: lesson.id,
      title: lesson.title,
      durationSec: lesson.durationSec,
      video: lesson.video,
    );
  }
}
