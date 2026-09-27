import 'package:flutter/material.dart';
import 'lesson_progress_bar.dart';
import 'playback_speed_menu.dart';

class VideoControls extends StatelessWidget {
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final double playbackSpeed;
  final bool isFullscreen;
  final VoidCallback onPlayPause;
  final ValueChanged<Duration> onSeek;
  final ValueChanged<double> onSpeedChanged;
  final VoidCallback onToggleFullscreen;

  const VideoControls({
    super.key,
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
    required this.playbackSpeed,
    required this.isFullscreen,
    required this.onPlayPause,
    required this.onSeek,
    required this.onSpeedChanged,
    required this.onToggleFullscreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withAlpha(200),
            Colors.black.withAlpha(50),
            Colors.black.withAlpha(0),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LessonProgressBar(
            currentPosition: currentPosition,
            totalDuration: totalDuration,
            onSeek: onSeek,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Playback Speed
              PlaybackSpeedMenu(
                currentSpeed: playbackSpeed,
                onSpeedSelected: onSpeedChanged,
              ),

              const Spacer(),

              // Play / Pause Button
              IconButton(
                onPressed: onPlayPause,
                iconSize: 42,
                color: Colors.white,
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_filled_rounded,
                ),
              ),

              const Spacer(),

              // Fullscreen Toggle Button
              IconButton(
                onPressed: onToggleFullscreen,
                color: Colors.white,
                icon: Icon(
                  isFullscreen
                      ? Icons.fullscreen_exit_rounded
                      : Icons.fullscreen_rounded,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
