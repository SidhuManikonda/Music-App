// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myportifolio/app_controller.dart';

final currentPositionProvider = StateProvider<Duration>((ref) => Duration.zero);
final dragPositionProvider = StateProvider<Duration?>((ref) => null);
final songDurationProvider =
    StateProvider<Duration>((ref) => Duration(seconds: 300));

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen( {super.key});
  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    var song = ref.watch(AppControllers.musicProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            song.currentSong != null ? "PLAYING RECOMMENDED SONGS FOR YOU" : "",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: SvgPicture.asset(
                    "images/icons8-music.svg",
                    fit: BoxFit.fitHeight,
                  )),
              SizedBox(
                height: 50,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Text(
                      song.currentSong?.title ?? '',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, bottom: 0),
                              child: Text(formatDuration(song.currentPosition)),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 20.0, bottom: 0),
                              child: Text(formatDuration(
                                  song.currentSong?.duration ?? Duration.zero)),
                            ),
                          ],
                        ),
                        Slider(
                          thumbColor: Colors.grey,
                          inactiveColor: Colors.grey,
                          activeColor: Colors.blueGrey[500],
                          allowedInteraction: SliderInteraction.tapAndSlide,
                          min: 0.0,
                          max: (song.currentSong?.duration?.inSeconds ?? 1)
                              .toDouble(),
                          value: song.currentPosition.inSeconds
                              .toDouble()
                              .clamp(
                                  0.0,
                                  (song.currentSong?.duration?.inSeconds ?? 1)
                                      .toDouble()),
                          onChanged: (val) {
                            ref
                                .read(AppControllers.musicProvider)
                                .dragSong(Duration(seconds: val.toInt()));
                          },
                          onChangeEnd: (val) {
                            ref
                                .read(AppControllers.musicProvider)
                                .endDragging();
                          }, 
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildSongChangeButton(
                                icon: Icons.fast_forward,
                                isRotate: true,
                                onTap: () {
                                  ref
                                      .read(AppControllers.musicProvider)
                                      .playPreviousSong();
                                }),
                            _buildSongChangeButton(
                                icon: song.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                isSize: true,
                                onTap: () {
                                  ref
                                      .read(AppControllers.musicProvider)
                                      .togglePausePlay();
                                }),
                            _buildSongChangeButton(
                                icon: Icons.fast_forward,
                                onTap: () {
                                  ref
                                      .read(AppControllers.musicProvider)
                                      .playNextSong();
                                }),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  String formatDuration(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  SizedBox _buildSongChangeButton(
      {bool isRotate = false,
      isSize = false,
      Function()? onTap,
      IconData? icon}) {
    return SizedBox(
      height: isSize ? 65 : 55,
      width: isSize ? 65 : 55,
      child: DecoratedBox(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
        child: Center(
          child: isRotate
              ? Transform.rotate(
                  angle: 3.14,
                  child: InkWell(
                    onTap: onTap,
                    child: Icon(
                      icon,
                      size: 30,
                    ),
                  ),
                )
              : InkWell(
                  onTap: onTap,
                  child: Icon(
                    icon,
                    size: 30,
                  ),
                ),
        ),
      ),
    );
  }
}
