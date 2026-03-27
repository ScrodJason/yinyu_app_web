class Track {
  final String id;
  final String title;
  final String artist;
  final Duration duration;
  final List<String> tags;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.tags,
  });
}

class Playlist {
  final String id;
  final String name;
  final List<String> trackIds;

  const Playlist({required this.id, required this.name, required this.trackIds});

  Playlist copyWith({String? name, List<String>? trackIds}) {
    return Playlist(id: id, name: name ?? this.name, trackIds: trackIds ?? this.trackIds);
  }
}
