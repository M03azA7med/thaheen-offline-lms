import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:thaheen_assessment/core/constants/app_constants.dart';
import 'package:thaheen_assessment/core/error/exceptions.dart';
import 'package:thaheen_assessment/data/models/course_model.dart';

abstract class CoursesLocalDataSource {
  Future<List<CourseModel>> getCourses();
  Future<CourseModel> getCourseDetails(String courseId);
}

class CoursesLocalDataSourceImpl implements CoursesLocalDataSource {
  final AssetBundle assetBundle;

  CoursesLocalDataSourceImpl({AssetBundle? assetBundle})
      : assetBundle = assetBundle ?? rootBundle;

  @override
  Future<List<CourseModel>> getCourses() async {
    try {
      final jsonString = await assetBundle.loadString(AppConstants.coursesJsonPath);
      final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      
      final rawCourses = jsonMap['courses'] as List<dynamic>? ?? [];
      return rawCourses
          .map((c) => CourseModel.fromJson(c as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw AssetException('Failed to load courses data: ${e.toString()}');
    }
  }

  @override
  Future<CourseModel> getCourseDetails(String courseId) async {
    final courses = await getCourses();
    final course = courses.firstWhere(
      (c) => c.id == courseId,
      orElse: () => throw AssetException('Course not found with id: $courseId'),
    );
    return course;
  }
}
