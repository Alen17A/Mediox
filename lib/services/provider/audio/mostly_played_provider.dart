

import 'package:flutter/material.dart';
import 'package:mediox/data/functions/audio/store_fetch_audios.dart';
import 'package:mediox/data/models/audio/audio_model.dart';

class MostlyPlayedProvider extends ChangeNotifier{

  List<AudioModel> mostlyPlayed = [];

  Future<void> getMostlyPlayedProvider() async {
    mostlyPlayed = await mostlyAudios();
    notifyListeners();
  }
}