import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoPlayerView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio > 0 ? controller.value.aspectRatio : (16 / 9),
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(controller),
        ],
      ),
    );
  }
}
