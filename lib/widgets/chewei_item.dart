import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CheweiItem extends StatefulWidget {
  final bool looping;
  final VideoPlayerController videoController;
  final bool isPlayScreen;

  CheweiItem(@required this.videoController, this.looping, this.isPlayScreen);

  @override
  State<CheweiItem> createState() => _CheweiItemState();
}

class _CheweiItemState extends State<CheweiItem> {
  ChewieController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = ChewieController(
      showControls: widget.isPlayScreen ? true : false,
      videoPlayerController: widget.videoController,
      aspectRatio: 16 / 9,
      looping: widget.looping,
      autoInitialize: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(controller: _controller!);
  }
}
