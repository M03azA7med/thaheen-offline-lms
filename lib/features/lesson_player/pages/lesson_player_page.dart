import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_assessment/core/constants/app_strings.dart';
import 'package:thaheen_assessment/core/theme/app_colors.dart';
import 'package:thaheen_assessment/features/lesson_player/cubit/lesson_player_cubit.dart';
import 'package:thaheen_assessment/features/lesson_player/cubit/lesson_player_state.dart';
import 'package:thaheen_assessment/features/lesson_player/widgets/next_lesson_button.dart';
import 'package:thaheen_assessment/features/lesson_player/widgets/video_controls.dart';
import 'package:thaheen_assessment/features/lesson_player/widgets/video_player_view.dart';

class LessonPlayerPage extends StatefulWidget {
  final String courseId;
  final String lessonId;

  const LessonPlayerPage({
    super.key,
    required this.courseId,
    required this.lessonId,
  });

  @override
  State<LessonPlayerPage> createState() => _LessonPlayerPageState();
}

class _LessonPlayerPageState extends State<LessonPlayerPage> {
  @override
  void initState() {
    super.initState();
    context.read<LessonPlayerCubit>().initializePlayer(
          courseId: widget.courseId,
          lessonId: widget.lessonId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<LessonPlayerCubit>().resetOrientation();
        }
      },
      child: BlocBuilder<LessonPlayerCubit, LessonPlayerState>(
        builder: (context, state) {
          if (state is LessonPlayerLoading) {
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }

          if (state is LessonPlayerError) {
            return Scaffold(
              appBar: AppBar(title: const Text('مشغل الفيديو')),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.videocam_off_outlined,
                        size: 72,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<LessonPlayerCubit>().initializePlayer(
                              courseId: widget.courseId,
                              lessonId: widget.lessonId,
                            ),
                        child: const Text(AppStrings.retry),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (state is LessonPlayerReady) {
            final cubit = context.read<LessonPlayerCubit>();
            final controller = cubit.videoController;

            if (controller == null) {
              return const SizedBox.shrink();
            }

            if (state.isFullscreen) {
              return Scaffold(
                backgroundColor: Colors.black,
                body: SafeArea(
                  child: Stack(
                    children: [
                      Center(child: VideoPlayerView(controller: controller)),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: VideoControls(
                          isPlaying: state.isPlaying,
                          currentPosition: state.currentPosition,
                          totalDuration: state.totalDuration,
                          playbackSpeed: state.playbackSpeed,
                          isFullscreen: state.isFullscreen,
                          onPlayPause: () => cubit.togglePlayPause(),
                          onSeek: (pos) => cubit.seekTo(pos),
                          onSpeedChanged: (speed) => cubit.setPlaybackSpeed(speed),
                          onToggleFullscreen: () => cubit.toggleFullscreen(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(state.lesson.title),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    // Video View with Controls Overlay
                    Container(
                      color: Colors.black,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          VideoPlayerView(controller: controller),
                          VideoControls(
                            isPlaying: state.isPlaying,
                            currentPosition: state.currentPosition,
                            totalDuration: state.totalDuration,
                            playbackSpeed: state.playbackSpeed,
                            isFullscreen: state.isFullscreen,
                            onPlayPause: () => cubit.togglePlayPause(),
                            onSeek: (pos) => cubit.seekTo(pos),
                            onSpeedChanged: (speed) => cubit.setPlaybackSpeed(speed),
                            onToggleFullscreen: () => cubit.toggleFullscreen(),
                          ),
                        ],
                      ),
                    ),

                    // Lesson Info & Controls
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.lesson.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  state.course.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Next Lesson Button or Course Completion Banner
                          NextLessonButton(
                            courseId: state.course.id,
                            nextLesson: state.nextLesson,
                            isCompleted: state.isCompleted,
                            isCourseCompleted: state.isCourseCompleted,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
