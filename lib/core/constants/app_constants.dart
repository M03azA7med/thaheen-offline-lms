class AppConstants {
  // Completion threshold formula: position / duration >= 0.90
  static const double completionThreshold = 0.90;

  // Assets
  static const String coursesJsonPath = 'assets/data/courses.json';

  // Persistence Keys
  static const String keyLessonProgressPrefix = 'lesson_progress_';
  static const String keyLastWatchedLesson = 'last_watched_lesson_id';
  static const String keyLastWatchedCourse = 'last_watched_course_id';
  static const String keyPlaybackSpeed = 'playback_speed';

  // Video Playback Speeds
  static const List<double> playbackSpeeds = [1.0, 1.25, 1.5, 2.0];
}
