import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mediox/data/functions/audio/playlists_audios.dart';
import 'package:mediox/data/models/audio/audio_model.dart';
import 'package:mediox/presentation/pages/audio/audio_playback/widgets/add_to_playlist_audios.dart';
import 'package:mediox/presentation/pages/audio/audio_playback/widgets/queryartwork_bg.dart';
import 'package:mediox/services/provider/audio/audio_playback_provider.dart';
import 'package:mediox/services/provider/audio/custom_audios_provider.dart';
import 'package:mediox/services/provider/audio/custom_playlist_provider.dart';
import 'package:mediox/services/provider/audio/mostly_played_provider.dart';
import 'package:mediox/services/provider/audio/recently_favourite_audios.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AudioPlaybackTestProvider extends StatefulWidget {
  final List<AudioModel> audioFile;
  final int index;
  String? category;
  AudioPlaybackTestProvider(
      {required this.audioFile, required this.index, this.category, super.key});

  @override
  State<AudioPlaybackTestProvider> createState() => _AudioPlaybackState();
}

class _AudioPlaybackState extends State<AudioPlaybackTestProvider> {
  late List<AudioModel> audioFiles;
  late int currentIndex;

  @override
  void initState() {
    audioFiles = widget.audioFile;
    currentIndex = widget.index;
    Provider.of<AudioPlaybackProvider>(context, listen: false)
        .initAudioPlayback(audioFile: audioFiles, index: currentIndex);
    recentlyMostlyProviderCall();
    super.initState();
  }

  void recentlyMostlyProviderCall() async {
    await Provider.of<RecentlyFavouriteAudiosProvider>(context, listen: false)
        .getRecentlySongsProvider();
    await Provider.of<MostlyPlayedProvider>(context, listen: false)
        .getMostlyPlayedProvider();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final audioPlaybackProvider = Provider.of<AudioPlaybackProvider>(context);
    final currentSong =
        audioPlaybackProvider.audioFiles[audioPlaybackProvider.currentIndex];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.category ??= "",
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 194, 192, 192)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      // backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background: Blurred artwork image
          QueryArtWorkBackground(audioId: currentSong.audioId),
          // Apply a blur effect over the background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: const Color.fromARGB(98, 0, 0, 0),
            ),
          ),
          // Main content overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Top row: Favourites & Custom Playlist Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<RecentlyFavouriteAudiosProvider>(
                        builder: (context, isFavouriteProvider, _) {
                          bool isFav = isFavouriteProvider
                              .isFavourite(currentSong.audioId);
                          return IconButton(
                            onPressed: () {
                              isFavouriteProvider.toggleFavourites(currentSong);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isFav
                                      ? "Removed from favourites"
                                      : "Added to favourites"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              size: 30,
                              color: isFav ? Colors.red : Colors.white,
                            ),
                          );
                        },
                      ),
                      AddToPlaylistAudios(songs: currentSong),
                      // IconButton(
                      //     onPressed: () {
                      //       showAddToPlaylistDialog(context, currentSong);
                      //     },
                      //     icon: const Icon(Icons.playlist_add)),
                    ],
                  ),
                  // Center: Album artwork, artist, and title
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 63, 62, 62),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: QueryArtworkWidget(
                          id: currentSong.audioId,
                          type: ArtworkType.AUDIO,
                          artworkHeight: 250,
                          artworkWidth: 250,
                          artworkBorder: BorderRadius.circular(125),
                          nullArtworkWidget: Container(
                            width: 250,
                            height: 250,
                            decoration: const BoxDecoration(
                              // color: Colors.grey,
                              gradient: LinearGradient(colors: [
                                Colors.green,
                                Color.fromARGB(255, 20, 101, 22)
                              ]),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.music_note,
                                size: 100, color: Colors.white),
                          ),
                          keepOldArtwork: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        currentSong.artist,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        currentSong.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  // Playback slider and durations
                  Consumer<AudioPlaybackProvider>(
                    builder: (context, playbackProvider, _) {
                      return Column(
                        children: [
                          Slider(
                            thumbColor: const Color(0xff253D2C),
                            activeColor: Colors.white,
                            inactiveColor:
                                const Color.fromARGB(255, 80, 80, 80),
                            min: 0,
                            max: playbackProvider.totalDuration.inSeconds > 0
                                ? playbackProvider.totalDuration.inSeconds
                                    .toDouble()
                                : 1.0,
                            value: playbackProvider.durationPosition.inSeconds
                                .toDouble()
                                .clamp(
                                    0.0,
                                    playbackProvider.totalDuration.inSeconds
                                        .toDouble()),
                            onChanged: (value) {
                              final newPosition =
                                  Duration(seconds: value.toInt());
                              playbackProvider.audioPlayer.seek(newPosition);
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    formatDuration(
                                        playbackProvider.durationPosition),
                                    style:
                                        const TextStyle(color: Colors.white)),
                                Text(
                                    formatDuration(
                                        playbackProvider.totalDuration),
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  // Playback controls row
                  Consumer<AudioPlaybackProvider>(
                    builder: (context, playbackProvider, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: playbackProvider.toggleRepeat,
                            icon: Icon(
                              playbackProvider.isRepeating
                                  ? Icons.repeat_one
                                  : Icons.repeat,
                              size: 30,
                              color: playbackProvider.isRepeating
                                  ? Colors.green
                                  : Colors.white70,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              playbackProvider.skipPrevious();
                              await Provider.of<
                                          RecentlyFavouriteAudiosProvider>(
                                      context,
                                      listen: false)
                                  .getRecentlySongsProvider();
                            },
                            icon: const Icon(Icons.skip_previous,
                                size: 40, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: playbackProvider.playPause,
                            icon: Icon(
                              playbackProvider.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              playbackProvider.skipNext();
                              await Provider.of<
                                          RecentlyFavouriteAudiosProvider>(
                                      context,
                                      listen: false)
                                  .getRecentlySongsProvider();
                            },
                            icon: const Icon(Icons.skip_next,
                                size: 40, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () async {
                              playbackProvider.shuffleAudios();
                              await Provider.of<
                                          RecentlyFavouriteAudiosProvider>(
                                      context,
                                      listen: false)
                                  .getRecentlySongsProvider();
                            },
                            icon: Icon(
                              Icons.shuffle,
                              size: 30,
                              color: playbackProvider.isShuffle
                                  ? Colors.green
                                  : Colors.white70,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showAddToPlaylistDialog(BuildContext context, AudioModel currentSong) {
    // Same implementation as before, just use currentSong directly
    showDialog(
      context: context,
      builder: (context) {
        String playlistName = "";
        return AlertDialog(
          title: const Text("Add to Playlist"),
          content: Consumer<CustomPlaylistProvider>(
            builder: (context, customPlaylistProvider, _) {
              return DropdownButtonFormField<String>(
                value: "0",
                onChanged: (playlistId) async {
                  if (playlistId == "0") {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Create new playlist"),
                        content: TextField(
                          onChanged: (value) => playlistName = value,
                          decoration: const InputDecoration(
                            hintText: "Playlist Name",
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              if (playlistName.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Enter a name for the playlist"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                await addSongToPlaylist(
                                  playlistAudios: [currentSong],
                                  playlistName: playlistName,
                                ).then((_) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Playlist $playlistName created"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                });
                                Provider.of<CustomPlaylistProvider>(context,
                                        listen: false)
                                    .getCustomPlaylistProvider();
                              }
                            },
                            child: const Text("OK"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    await addSongToPlaylist(
                      playlistAudios: [currentSong],
                      playlistId: playlistId!,
                    ).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Added to Playlist"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    });
                    Provider.of<CustomPlaylistProvider>(context, listen: false)
                        .getCustomPlaylistProvider();
                    Provider.of<CustomAudiosProvider>(context, listen: false)
                        .getCustomAudiosProvider(playlistId);
                  }
                },
                items: [
                  const DropdownMenuItem(
                    value: "0",
                    child: Text("Create new playlist",
                        style: TextStyle(color: Colors.green)),
                  ),
                  ...List.generate(
                    customPlaylistProvider.customPlaylists.length,
                    (index) {
                      return DropdownMenuItem(
                        value: customPlaylistProvider
                            .customPlaylists[index].playlistId,
                        child: Text(customPlaylistProvider
                            .customPlaylists[index].playlistName),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
