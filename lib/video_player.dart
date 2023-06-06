import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:video_player/video_player.dart';

class Video extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool loop;
  const Video({
    Key? key,
    required this.videoPlayerController,
    required this.loop,
  }) : super(key: key);

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        looping: widget.loop,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        autoPlay: true,
        zoomAndPan: true,
        controlsSafeAreaMinimum: const EdgeInsets.all(12.0));
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(controller: _chewieController);
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  String videoId = dotenv.env['videoId']!;
  String resolutionHeight = dotenv.env['resolutionHeight']!;
  String apiKey = dotenv.env["apiKey"]!;
  String pullZoneUrl = dotenv.env["pullZoneUrl"]!;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Video(
          videoPlayerController: VideoPlayerController.network(
              //https://vz-6c12489b-03e.b-cdn.net/75d7bbf8-b441-4f9d-957f-983ba0d37b68/play_720p.mp4
              "https://$pullZoneUrl.b-cdn.net/$videoId/play_${resolutionHeight}p.mp4",
              httpHeaders: {
                "AccessKey": apiKey,
                "Content-Type": "application/json"
              }),
          loop: true),
    );
  }
}
