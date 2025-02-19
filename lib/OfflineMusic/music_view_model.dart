import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myportifolio/OfflineMusic/music_services.dart';
import 'package:myportifolio/OfflineMusic/song_model.dart';
import 'package:myportifolio/app_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class MusicViewModel {
  final MusicServices musicServices = MusicServices();

  final WidgetRef ref;
  MusicViewModel(this.ref) {
    _loadAllFiles();
  }

  Future<void> _loadAllFiles() async {
    if (Platform.isAndroid) {
      if (await _requestPermissions()) {
        final rootDir = Directory("/storage/emulated/0/");
        if (await rootDir.exists()) {
          var files = await _getAllMp3Files(rootDir);
          ref.read(AppControllers.musicProvider).isLoading = false;
          ref.read(AppControllers.musicProvider).mp3Files = files;
        } else {
          debugPrint("Music directory not found");
        }
      } else {
        debugPrint("Permission not granted");
      }
    }
  }

  Future<List<SongModel>> _getAllMp3Files(Directory directory) async {
    List<SongModel> files = [];
    try {
      List<FileSystemEntity> entities = directory.listSync();
      for (var entity in entities) {
        if (entity is Directory &&
            !entity.path.contains('PLAYit') &&
            !entity.path.contains("Android/data") &&
            !entity.path.contains("Android/obb")) {
          files.addAll(await _getAllMp3Files(entity));
        } else if (entity is File && entity.path.endsWith('.mp3')) {
          String fileName = entity.uri.pathSegments.last;

// Remove unwanted text patterns
          String cleanedName = fileName
              .replaceAll(
                  RegExp(
                      r"\b(?:iSongs\.info|SenSongsMp3\.Co|SenSongsMp\.Co|mp3)\b",
                      caseSensitive: false),
                  "")
              .replaceAll(RegExp(r"[\d\[\]\(\)_\-.]"), " ")
              .replaceAll(RegExp(r"\s+"), " ")
              .trim();

          Duration? duration = await musicServices.getDuration(entity.path);
          files.add(
            SongModel(
              path: entity.path,
              title: cleanedName,
              duration: duration ?? Duration.zero,
            ),
          );
          files.sort((a, b) =>
              a.title!.toLowerCase().compareTo(b.title!.toLowerCase()));
        }
      }
      return files;
    } catch (e) {
      debugPrint("Error reading directory: $e");
      return [];
    }
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      var status = await Permission.manageExternalStorage.request();
      debugPrint("Storage Permission Status: $status");

      if (status.isPermanentlyDenied) {
        debugPrint("Permission permanently denied. Opening settings...");
        await openAppSettings();
      }

      return status.isGranted;
    }
    return true;
  }
}
