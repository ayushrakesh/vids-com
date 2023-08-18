import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CheweiItem extends StatefulWidget {
  final bool looping;
  final VideoPlayerController videoController;

  CheweiItem(@required this.videoController, this.looping);

  @override
  State<CheweiItem> createState() => _CheweiItemState();
}

class _CheweiItemState extends State<CheweiItem> {
  ChewieController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = ChewieController(
      showControls: true,
      videoPlayerController: widget.videoController,
      aspectRatio: 16 / 10,
      looping: widget.looping,
      autoInitialize: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(controller: _controller!);
  }
}
