import 'package:flutter/material.dart';
import 'package:mediox/services/provider/audio/get_audios_provider.dart';
import 'package:mediox/services/provider/audio/mostly_played_provider.dart';
import 'package:mediox/services/provider/audio/recently_favourite_audios.dart';
import 'package:provider/provider.dart';

class AudiosSearch extends StatelessWidget {
  const AudiosSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<GetAudiosProvider>(context);
    final recentAudioProvider =
        Provider.of<RecentlyFavouriteAudiosProvider>(context);
    final mostlyAudioProvider = Provider.of<MostlyPlayedProvider>(context);
    final favoriteAudioProvider =
        Provider.of<RecentlyFavouriteAudiosProvider>(context);

    return SearchBar(
      leading: const Icon(Icons.search),
      hintText: "Search Audios....",
      shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      shadowColor: const WidgetStatePropertyAll(Color(0xff2E6F40)),
      onChanged: (query) {
        audioProvider.search(query);
        recentAudioProvider.search(query);
        mostlyAudioProvider.search(query);
        favoriteAudioProvider.search(query);
      },
    );
  }
}
