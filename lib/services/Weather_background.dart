import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WeatherBackground extends StatefulWidget {
  late final bool isDaytime;

  @override
  State<WeatherBackground> createState() => _WeatherBackgroundState();
}

class _WeatherBackgroundState extends State<WeatherBackground> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.asset(
        widget.isDaytime ? 'assets/videos/daytime.mp4' : 'assets/videos/nighttime.mp4'
    )..initialize().then((_) {
      _controller.play();
      _controller.setLooping(true);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    )
        : Container(color: Colors.black);
  }
}
