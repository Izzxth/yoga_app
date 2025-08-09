class Pose {
  final String name;
  final String imagePath;
  final String audioPath;
  final int duration;

  Pose({
    required this.name,
    required this.imagePath,
    required this.audioPath,
    required this.duration,
  });

  /// We no longer read the maps here, we get actual filenames from loader
  factory Pose.fromResolved({
    required String name,
    required String imageFile,
    required String audioFile,
    required int duration,
  }) {
    return Pose(
      name: name,
      imagePath: 'assets/images/$imageFile',
      audioPath: 'assets/audio/$audioFile',
      duration: duration,
    );
  }
}
