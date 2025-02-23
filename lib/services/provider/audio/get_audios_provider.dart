import 'package:flutter/material.dart';
import 'package:mediox/data/functions/audio/store_fetch_audios.dart';
import 'package:mediox/data/models/audio/audio_model.dart';

class GetAudiosProvider extends ChangeNotifier {
  List<AudioModel> allAudios = [];

  Future<void> getAllAudios() async{
    allAudios = await getSongs();
    notifyListeners();
  }
}
