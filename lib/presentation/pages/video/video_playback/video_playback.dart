import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mediox/data/functions/video/playlists_videos.dart';
import 'package:mediox/data/models/video/video_model.dart';
import 'package:mediox/services/provider/video/mostly_videos_provider.dart';
import 'package:mediox/services/provider/video/recently_favourite_videos.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayback extends StatefulWidget {
  final List<VideoModel> playbackVideos;
  final int videoIndex;
  const VideoPlayback(
      {super.key, required this.playbackVideos, required this.videoIndex});

  @override
  State<VideoPlayback> createState() => _VideoPlaybackState();
}

class _VideoPlaybackState extends State<VideoPlayback> {
  late VideoPlayerController _videoPlayer;
  late int currentIndex;
  bool isWatching = true;
  Duration totalDuration = Duration.zero;
  Duration durationPosition = Duration.zero;

  @override
  void initState() {
    initVideoPlayback();
    super.initState();
  }

  Future<void> initVideoPlayback() async {
    currentIndex = widget.videoIndex;
    setVideoSource(widget.playbackVideos[currentIndex].videoPath);
    await addVideoToPlaylist(
        playlistVideos: [widget.playbackVideos[currentIndex]],
        playlistName: "Recently Played",
        playlistId: "recentlyPlayed");
    await Provider.of<RecentlyFavouriteVideosProvider>(context, listen: false)
        .getRecentlyVideosProvider();
    setState(() {
      widget.playbackVideos[currentIndex].playCount++;
    });
    await widget.playbackVideos[currentIndex].save();
    await Provider.of<MostlyVideosProvider>(context, listen: false)
        .getMostlyPlayedVideosProvider();
  }

  Future<void> setVideoSource(String videoPath) async {
    _videoPlayer = VideoPlayerController.file(
        File(widget.playbackVideos[currentIndex].videoPath))
      ..initialize().then((_) {
        setState(() {
          totalDuration = _videoPlayer.value.duration;
        });
        _videoPlayer.play();
      });

    _videoPlayer.addListener(() {
      setState(() {
        durationPosition = _videoPlayer.value.position;
      });
    });
  }

  void playPauseVideo() {
    if (isWatching) {
      _videoPlayer.pause();
    } else {
      _videoPlayer.play();
    }
    setState(() {
      isWatching = !isWatching;
    });
  }

  Future<void> skipNext() async {
    if (currentIndex < widget.playbackVideos.length - 1) {
      setState(() {
        currentIndex++;
      });
      setVideoSource(widget.playbackVideos[currentIndex].videoPath);
      await _videoPlayer.play();
      setState(() {
        isWatching = true;
      });
      await addVideoToPlaylist(
          playlistVideos: [widget.playbackVideos[currentIndex]],
          playlistName: "Recently Played",
          playlistId: "recentlyPlayed");
      await Provider.of<RecentlyFavouriteVideosProvider>(context, listen: false)
          .getRecentlyVideosProvider();
      setState(() {
        widget.playbackVideos[currentIndex].playCount++;
      });
      await widget.playbackVideos[currentIndex].save();
    }
  }

  Future<void> skipPrevious() async {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      setVideoSource(widget.playbackVideos[currentIndex].videoPath);
      _videoPlayer.play();
      setState(() {
        isWatching = true;
      });
      await addVideoToPlaylist(
          playlistVideos: [widget.playbackVideos[currentIndex]],
          playlistName: "Recently Played",
          playlistId: "recentlyPlayed");
      await Provider.of<RecentlyFavouriteVideosProvider>(context, listen: false)
          .getRecentlyVideosProvider();
      setState(() {
        widget.playbackVideos[currentIndex].playCount++;
      });
      await widget.playbackVideos[currentIndex].save();
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            _videoPlayer.value.isInitialized
                ? Center(
                    child: AspectRatio(
                      aspectRatio: _videoPlayer.value.aspectRatio,
                      child: VideoPlayer(_videoPlayer),
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: skipPrevious,
                    icon: const Icon(
                      Icons.skip_previous,
                      size: 40,
                      color: Colors.white,
                    )),
                IconButton(
                    onPressed: playPauseVideo,
                    icon: Icon(
                      isWatching
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 80,
                      color: Colors.white,
                    )),
                IconButton(
                    onPressed: skipNext,
                    icon: const Icon(
                      Icons.skip_next,
                      size: 40,
                      color: Colors.white,
                    )),
              ],
            ),
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Slider(
                thumbColor: Colors.white,
                activeColor: const Color.fromARGB(255, 94, 92, 92),
                min: 0,
                max: totalDuration.inSeconds.toDouble(),
                value: durationPosition.inSeconds.toDouble(),
                onChanged: (value) {
                  final newPosition = Duration(seconds: value.toInt());
                  _videoPlayer.seekTo(newPosition);
                },
              ),
            ),
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    formatDuration(durationPosition),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 150,
                  ),
                  Text(
                    formatDuration(totalDuration),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    _videoPlayer.dispose();
    super.dispose();
  }
}
