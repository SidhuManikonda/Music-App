import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myportifolio/OfflineMusic/music_services.dart';
import 'package:myportifolio/OfflineMusic/song_model.dart';
import 'package:myportifolio/main.dart';

class MusicController extends ChangeNotifier {
  //
  final MusicServices musicServices = MusicServices();
  SongModel? _currentSong;
  List<SongModel> _mp3Files = [];
  bool _isLoading = true;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration? _dragPosition;
  //getters
  List<SongModel> get mp3Files => _mp3Files;
  SongModel? get currentSong => _currentSong;
  Duration get currentPosition => _dragPosition ?? _currentPosition;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  //
  set mp3Files(List<SongModel> data) {
    _mp3Files = data;
    notifyListeners();
  }

  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  set isPlaying(bool val) {
    _isPlaying = val;
    notifyListeners();
  }

  set currentSong(SongModel? song) {
    _currentSong = song;
    notifyListeners();
  }

  Future<void> playSong(SongModel song, {Duration? startPosition}) async {
    showSongNotification(song.title ?? '', song.title ?? '');
    _currentSong = song;
    _isPlaying = true;
    _currentPosition = Duration.zero;
    notifyListeners();
    await musicServices.play(song.path!);
    if (startPosition != null) {
      await musicServices.seek(startPosition);
    }
    musicServices.positionStream.listen((position) {
      if (_dragPosition == null) {
        _currentPosition = position;
        notifyListeners();
      }
    });
    musicServices.durationStream.listen((duration) {
      if (_currentSong != null) {
        _currentSong!.duration = duration;
        notifyListeners();
      }
    });
    musicServices.onComplete = () {
      playNextSong();
    };
  }

  Future<void> pause() async {
    await musicServices.pause();
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> togglePausePlay() async {
    if (isPlaying) {
      musicServices.pause();
    } else {
      if (currentPosition > currentSong!.duration!) {
        playNextSong();
      } else {
        musicServices.resume();
      }
    }
    isPlaying = !isPlaying;
    notifyListeners();
  }

  Future<void> resume() async {
    await musicServices.resume();
    _isPlaying = true;
    notifyListeners();
  }

  Future<void> stop() async {
    await musicServices.stop();
    _isPlaying = false;
    _currentSong = null;
    _currentPosition = Duration.zero;
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await musicServices.seek(position);
    _currentPosition = position;
    _dragPosition = null;
    notifyListeners();
  }

  void dragSong(Duration position) {
    _dragPosition = position;
    notifyListeners();
  }

  void endDragging() {
    if (_dragPosition != null) {
      seek(_dragPosition!);
      _dragPosition = null;
    }
  }

  void playNextSong() {
    if (_currentSong != null) {
      int currentIndex = _mp3Files.indexOf(_currentSong!);
      int nextIndex = (currentIndex + 1) % _mp3Files.length;
      _currentSong = _mp3Files[nextIndex];
      playSong(_currentSong!);
    }
  }

  void playPreviousSong() {
    if (_currentSong != null && isPlaying || !isPlaying) {
      int currentIndex = _mp3Files.indexOf(_currentSong!);
      int previousIndex = (currentIndex - 1) % _mp3Files.length;
      _currentSong = _mp3Files[previousIndex];
      playSong(_currentSong!);
    }
  }

  Future<void> showSongNotification(String songTitle, String artist) async {
    var androidDetails = AndroidNotificationDetails(
      'song_channel_id',
      'Song Notifications',
      channelDescription: 'Notifications for currently playing songs.',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );

    var notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      songTitle,
      artist,
      notificationDetails,
      payload: 'Song is playing',
    );
  }

  Future<void> deleteSong(
      String path, /* AudioPlayer audioPlayer */ BuildContext context) async {
    try {
      if (_currentSong != null && _currentSong!.path == path) {
        await stop();
      }
      File file = File(path);
      if (await file.exists()) {
        await file.delete();
        mp3Files = _mp3Files.where((song) => song.path != path).toList();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("File deleted Successfully")));
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("File does not exists!")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error deleting file: $e")));
      }
    }
  }

  Future<void> deleteMultipleSongs(List<String> paths,
      /* AudioPlayer audioPlayer */ BuildContext context) async {
    try {
      if (_currentSong != null && paths.contains(_currentSong?.path)) {
        await stop();
      }
      for (var path in paths) {
        File file = File(path);
        if (await file.exists()) {
          await file.delete();
          mp3Files = _mp3Files.where((song) => song.path != path).toList();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Files deleted Successfully")));
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("File does not exists!")));
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error deleting files: $e")));
      }
    }
  }
}
