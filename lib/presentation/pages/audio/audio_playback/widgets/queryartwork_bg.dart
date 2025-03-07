import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class QueryArtWorkBackground extends StatelessWidget {
  final int audioId;
  const QueryArtWorkBackground({super.key, required this.audioId});

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
            key: ValueKey(audioId),
            id: audioId,
            type: ArtworkType.AUDIO,
            artworkFit: BoxFit.cover,
            artworkQuality: FilterQuality.high,
            nullArtworkWidget: Container(color: Colors.grey),
            keepOldArtwork: true,
          );
  }
}