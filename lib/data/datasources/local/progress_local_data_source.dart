import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thaheen_assessment/core/constants/app_constants.dart';
import 'package:thaheen_assessment/core/error/exceptions.dart';
import 'package:thaheen_assessment/data/models/lesson_progress_model.dart';

abstract class ProgressLocalDataSource {
  Future<LessonProgressModel?> getLessonProgress(String lessonId);
  Future<void> saveLessonProgress(LessonProgressModel progress);
  Future<Map<String, LessonProgressModel>> getAllProgress();
  Future<String?> getLastWatchedLessonId();
  Future<void> saveLastWatchedLesson(String courseId, String lessonId);
  Future<double> getPlaybackSpeed();
  Future<void> savePlaybackSpeed(double speed);
}

class ProgressLocalDataSourceImpl implements ProgressLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProgressLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<LessonProgressModel?> getLessonProgress(String lessonId) async {
    try {
      final key = '${AppConstants.keyLessonProgressPrefix}$lessonId';
      final jsonString = sharedPreferences.getString(key);
      if (jsonString == null) return null;
      final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return LessonProgressModel.fromJson(jsonMap);
    } catch (e) {
      throw CacheException('Failed to read lesson progress: ${e.toString()}');
    }
  }

  @override
  Future<void> saveLessonProgress(LessonProgressModel progress) async {
    try {
      final key = '${AppConstants.keyLessonProgressPrefix}${progress.lessonId}';
      final jsonString = json.encode(progress.toJson());
      await sharedPreferences.setString(key, jsonString);
    } catch (e) {
      throw CacheException('Failed to save lesson progress: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, LessonProgressModel>> getAllProgress() async {
    try {
      final Map<String, LessonProgressModel> result = {};
      final keys = sharedPreferences.getKeys();
      for (final key in keys) {
        if (key.startsWith(AppConstants.keyLessonProgressPrefix)) {
          final lessonId = key.substring(AppConstants.keyLessonProgressPrefix.length);
          final jsonString = sharedPreferences.getString(key);
          if (jsonString != null) {
            final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;
            result[lessonId] = LessonProgressModel.fromJson(jsonMap);
          }
        }
      }
      return result;
    } catch (e) {
      throw CacheException('Failed to fetch all progress: ${e.toString()}');
    }
  }

  @override
  Future<String?> getLastWatchedLessonId() async {
    return sharedPreferences.getString(AppConstants.keyLastWatchedLesson);
  }

  @override
  Future<void> saveLastWatchedLesson(String courseId, String lessonId) async {
    await sharedPreferences.setString(AppConstants.keyLastWatchedCourse, courseId);
    await sharedPreferences.setString(AppConstants.keyLastWatchedLesson, lessonId);
  }

  @override
  Future<double> getPlaybackSpeed() async {
    return sharedPreferences.getDouble(AppConstants.keyPlaybackSpeed) ?? 1.0;
  }

  @override
  Future<void> savePlaybackSpeed(double speed) async {
    await sharedPreferences.setDouble(AppConstants.keyPlaybackSpeed, speed);
  }
}
