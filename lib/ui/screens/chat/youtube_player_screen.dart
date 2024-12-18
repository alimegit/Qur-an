import 'package:flutter/material.dart';
import 'package:learn_quran/util/app_colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerScreen extends StatefulWidget {
  const YoutubePlayerScreen({super.key});

  @override
 State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'PLHddf-1MHY',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        loop: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Al-Fatih video'),
        backgroundColor: AppColors.learnMainColor,
      ),
      body: Column(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            onReady: () {
              _controller.addListener(() {});
            },
          ),
        ],
      ),
    );
  }
}