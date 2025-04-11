import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediox/data/models/video/video_model.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

late LazyBox<VideoModel> videoBox;

Future<void> fetchVideosWithHive() async {
  final PermissionState videoPermission =
      await PhotoManager.requestPermissionExtend();
  debugPrint("Permission status: $videoPermission");
  if (!videoPermission.isAuth) {
    PhotoManager.openSetting();
  }

  List<AssetEntity> videoAssets = await PhotoManager.getAssetListPaged(
    type: RequestType.video,
    page: 0,
    pageCount: 100,
  );

  for (AssetEntity videoAsset in videoAssets) {
    if (!checkVideo(videoId: videoAsset.id)) {
      final File? file = await videoAsset.file;
      final Uint8List? thumbnail =
          await VideoThumbnail.thumbnailData(video: file!.path);
      var videoModel = VideoModel(
          videoId: videoAsset.id,
          videoTitle: videoAsset.title!,
          videoPath: file.path,
          thumbnail: thumbnail);
      await videoBox.put(videoModel.videoId, videoModel);
    }
  }
}

bool checkVideo({required String videoId}) {
  return videoBox.containsKey(videoId);
}

Future<List<VideoModel>> getVideos() async {
  final List<VideoModel> videosList = [];
  for (var key in videoBox.keys) {
    VideoModel? videoModel = await videoBox.get(key);
    if (videoModel != null) {
      videosList.add(videoModel);
    }
  }

  return videosList;
}

Future<List<VideoModel>> mostlyVideos() async {
  List<VideoModel> videos = [];
  for (String key in videoBox.keys) {
    VideoModel? videoModel = await videoBox.get(key);
    if (videoModel != null) {
      if (videoModel.playCount >= 5) {
        videos.add(videoModel);
      }
    }
  }
  videos.sort((a, b) => b.playCount.compareTo(a.playCount));
  return videos;
}
