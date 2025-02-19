import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myportifolio/OfflineMusic/music_view_model.dart';
import 'package:myportifolio/OfflineMusic/screens/player_screen.dart';
import 'package:myportifolio/app_controller.dart';

final longPressProvider = StateProvider<String?>((ref) => null);
final selectedSongsProvider = StateProvider<Set<String>>((ref) => {});

class MusicPlayerScreen extends ConsumerStatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  ConsumerState<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends ConsumerState<MusicPlayerScreen> {
  bool isChecked = false;

  late MusicViewModel musicViewModel;
  @override
  void initState() {
    musicViewModel = MusicViewModel(ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(AppControllers.musicProvider);
    final isLoading = ref.watch(AppControllers.musicProvider).isLoading;
    final isPlaying = ref.watch(AppControllers.musicProvider).isPlaying;
    final deleteSongController = ref.watch(longPressProvider);
    final selectedSongs = ref.watch(selectedSongsProvider);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selectedSongs.isNotEmpty
          ? FloatingActionButton(
              elevation: 5,
              backgroundColor: Colors.grey[300],
              onPressed: () {
                if (selectedSongs.isNotEmpty) {
                  _confirmDeleteSong(context, selectedSongs.toList(),
                      multipleSongs: true);
                }
              },
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )
          : null,
      appBar: AppBar(
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: PopupMenuButton<String>(
                onSelected: (val) {
                  if (val == "select_all") {
                    ref.read(longPressProvider.notifier).state = "select_all";
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: "select_all",
                    child: Text("Select All"),
                  ),
                ],
                icon: Icon(Icons.more_vert_outlined),
              ))
        ],
        title: Center(
          child: Text(
            "M U S I C  P L A Y E R",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: InkWell(
        onTap: () {
          ref.read(longPressProvider.notifier).state = null;
        },
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : player.mp3Files.isEmpty
                ? Center(
                    child: Text(
                      "No Songs To Display",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              itemCount: player.mp3Files.length,
                              itemBuilder: (context, index) {
                                final song = player.mp3Files[index];
                                final isLongPressed =
                                    deleteSongController == song.path ||
                                        deleteSongController == "select_all";
                                return ListTile(
                                  trailing: isLongPressed &&
                                          deleteSongController == "select_all"
                                      ? Checkbox(
                                          value:
                                              selectedSongs.contains(song.path),
                                          onChanged: (val) {
                                            ref
                                                .read(selectedSongsProvider
                                                    .notifier)
                                                .state = {
                                              if (val == true) ...selectedSongs,
                                              if (val == true) song.path!,
                                              if (val == false)
                                                ...selectedSongs.where(
                                                    (item) => item != song.path)
                                            };
                                          })
                                      : isLongPressed
                                          ? InkWell(
                                              onTap: () {
                                                _confirmDeleteSong(
                                                    context, [song.path ?? '']);
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            )
                                          : player.currentSong?.path ==
                                                  song.path
                                              ? InkWell(
                                                  onTap: () {
                                                    isPlaying
                                                        ? ref
                                                            .read(AppControllers
                                                                .musicProvider)
                                                            .pause()
                                                        : ref
                                                            .read(AppControllers
                                                                .musicProvider)
                                                            .resume();
                                                  },
                                                  child: Icon(isPlaying
                                                      ? Icons.pause
                                                      : Icons.play_arrow))
                                              : null,
                                  leading: Icon(Icons.music_note),
                                  onTap: () {
                                    ref.read(longPressProvider.notifier).state =
                                        null;

                                    ref
                                        .read(AppControllers.musicProvider)
                                        .playSong(song);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PlayerScreen()));
                                  },
                                  onLongPress: () {
                                    ref.read(longPressProvider.notifier).state =
                                        song.path;
                                  },
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        song.title.toString(),
                                      ),
                                    ],
                                  ),
                                );
                              }))
                    ],
                  ),
      ),
    );
  }

  void _confirmDeleteSong(BuildContext context, List<String>? songPaths,
      {bool multipleSongs = false}) {
    final selectedSongs = ref.watch(selectedSongsProvider);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Delete Song",
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        content: multipleSongs
            ? Text("Are you sure you want to delete this song?")
            : Text("Are you sure you want to delete all these song?"),
        actions: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: Colors.grey),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (multipleSongs) {
                ref
                    .read(AppControllers.musicProvider)
                    .deleteMultipleSongs(songPaths!, context);
                ref.read(selectedSongsProvider.notifier).state = {
                  ...selectedSongs
                      .where((songPath) => !songPath.contains(songPath))
                };
              }
              ref
                  .read(AppControllers.musicProvider)
                  .deleteSong(songPaths![0], context);
              ref.read(selectedSongsProvider.notifier).state = {
                ...selectedSongs.where((songPath) => songPath != songPaths[0])
              };
              ref.read(longPressProvider.notifier).state = null;
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: Colors.red),
              child: Text(
                multipleSongs ? "Delete Selected Songs" : "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
