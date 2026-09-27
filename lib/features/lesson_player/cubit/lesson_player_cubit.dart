import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:thaheen_assessment/core/utils/progress_utils.dart';
import 'package:thaheen_assessment/domain/entities/lesson.dart';
import 'package:thaheen_assessment/domain/entities/lesson_progress.dart';
import 'package:thaheen_assessment/domain/repositories/progress_repository.dart';
import 'package:thaheen_assessment/domain/usecases/get_course_details.dart';
import 'lesson_player_state.dart';

class LessonPlayerCubit extends Cubit<LessonPlayerState> {
  final GetCourseDetails getCourseDetails;
  final ProgressRepository progressRepository;

  VideoPlayerController? _videoController;
  VideoPlayerController? get videoController => _videoController;

  Timer? _progressDebounceTimer;

  LessonPlayerCubit({
    required this.getCourseDetails,
    required this.progressRepository,
  }) : super(LessonPlayerInitial());

  Future<void> initializePlayer({
    required String courseId,
    required String lessonId,
  }) async {
    emit(LessonPlayerLoading());
    try {
      await _disposeController();

      final course = await getCourseDetails(courseId);
      final flattened = course.flattenedLessons;

      final currentIndex = flattened.indexWhere((l) => l.id == lessonId);
      if (currentIndex == -1) {
        emit(const LessonPlayerError('الدرس غير موجود في هذه الدورة.'));
        return;
      }

      final lesson = flattened[currentIndex];

      // Next lesson in flattened order
      Lesson? nextLesson;
      bool isCourseCompleted = false;
      if (currentIndex + 1 < flattened.length) {
        nextLesson = flattened[currentIndex + 1];
      } else {
        isCourseCompleted = true;
      }

      // Fetch saved progress & speed preference
      final savedProgress = await progressRepository.getLessonProgress(lessonId);
      final savedSpeed = await progressRepository.getPlaybackSpeed();

      // Save last watched lesson
      await progressRepository.saveLastWatchedLesson(courseId, lessonId);

      // Create & initialize video controller
      _videoController = VideoPlayerController.asset(lesson.video);
      await _videoController!.initialize();
      await _videoController!.setPlaybackSpeed(savedSpeed);

      final totalDurationSec = _videoController!.value.duration.inSeconds > 0
          ? _videoController!.value.duration.inSeconds
          : lesson.durationSec;

      // Resume position safely
      int resumeSec = savedProgress?.positionSeconds ?? 0;
      if (resumeSec >= totalDurationSec) {
        resumeSec = 0; // If already watched to end previously, restart from 0
      }
      final resumeDuration = Duration(seconds: resumeSec);
      await _videoController!.seekTo(resumeDuration);

      final initialProgress = savedProgress ??
          LessonProgress(
            lessonId: lessonId,
            positionSeconds: resumeSec,
            completed: false,
          );

      _videoController!.addListener(_onVideoControllerUpdate);

      emit(LessonPlayerReady(
        course: course,
        lesson: lesson,
        nextLesson: nextLesson,
        progress: initialProgress,
        isPlaying: false,
        currentPosition: resumeDuration,
        totalDuration: Duration(seconds: totalDurationSec),
        playbackSpeed: savedSpeed,
        isCompleted: initialProgress.completed,
        isFullscreen: false,
        isCourseCompleted: isCourseCompleted,
      ));
    } catch (e) {
      emit(LessonPlayerError('تعذر تشغيل هذا الفيديو: ${e.toString()}'));
    }
  }

  void _onVideoControllerUpdate() {
    if (_videoController == null || state is! LessonPlayerReady) return;

    final readyState = state as LessonPlayerReady;
    final currentPos = _videoController!.value.position;
    final totalDur = _videoController!.value.duration;
    final isPlaying = _videoController!.value.isPlaying;

    final posSec = currentPos.inSeconds;
    final durSec = totalDur.inSeconds > 0 ? totalDur.inSeconds : readyState.lesson.durationSec;

    // Check auto completion (>= 90%)
    bool isCompletedNow = readyState.isCompleted;
    if (!isCompletedNow && ProgressUtils.isLessonCompleted(positionSeconds: posSec, durationSeconds: durSec)) {
      isCompletedNow = true;
    }

    final updatedProgress = readyState.progress.copyWith(
      positionSeconds: posSec,
      completed: isCompletedNow,
      lastWatchedAt: DateTime.now(),
    );

    // Save progress to SharedPreferences periodically
    _debounceSaveProgress(updatedProgress);

    emit(readyState.copyWith(
      isPlaying: isPlaying,
      currentPosition: currentPos,
      totalDuration: Duration(seconds: durSec),
      isCompleted: isCompletedNow,
      progress: updatedProgress,
    ));
  }

  void play() {
    _videoController?.play();
  }

  void pause() {
    _videoController?.pause();
  }

  void togglePlayPause() {
    if (_videoController == null) return;
    if (_videoController!.value.isPlaying) {
      pause();
    } else {
      play();
    }
  }

  void seekTo(Duration position) {
    if (_videoController == null) return;
    _videoController!.seekTo(position);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    if (_videoController == null) return;
    await _videoController!.setPlaybackSpeed(speed);
    await progressRepository.savePlaybackSpeed(speed);
    if (state is LessonPlayerReady) {
      emit((state as LessonPlayerReady).copyWith(playbackSpeed: speed));
    }
  }

  void toggleFullscreen() {
    if (state is! LessonPlayerReady) return;
    final current = (state as LessonPlayerReady).isFullscreen;
    final newFullscreen = !current;

    if (newFullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    emit((state as LessonPlayerReady).copyWith(isFullscreen: newFullscreen));
  }

  void resetOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _debounceSaveProgress(LessonProgress progress) {
    _progressDebounceTimer?.cancel();
    _progressDebounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await progressRepository.saveLessonProgress(progress);
    });
  }

  Future<void> _disposeController() async {
    _progressDebounceTimer?.cancel();
    if (_videoController != null) {
      _videoController!.removeListener(_onVideoControllerUpdate);
      await _videoController!.dispose();
      _videoController = null;
    }
  }

  @override
  Future<void> close() async {
    resetOrientation();
    await _disposeController();
    return super.close();
  }
}
