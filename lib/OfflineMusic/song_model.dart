class SongModel {
  String? title;
  String? path;
  Duration? duration;
  Duration? position;
  SongModel(
      {this.title,
      this.path,
      this.duration = Duration.zero,
      this.position = Duration.zero});
  factory SongModel.fromFile(String filePath) {
    return SongModel()
      ..title = filePath.split('/').last.replaceAll('.mp3', '')
      ..path = filePath
      ..duration = Duration.zero
      ..position = Duration.zero;
  }
}
