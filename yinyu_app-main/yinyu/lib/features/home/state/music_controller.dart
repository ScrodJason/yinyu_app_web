import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'music_models.dart';
import 'music_repository.dart';

class MusicState {
  final String query;
  final Set<String> favorites;
  final List<Playlist> playlists;

  const MusicState({required this.query, required this.favorites, required this.playlists});

  factory MusicState.initial() => const MusicState(query: '', favorites: {}, playlists: []);

  MusicState copyWith({String? query, Set<String>? favorites, List<Playlist>? playlists}) {
    return MusicState(
      query: query ?? this.query,
      favorites: favorites ?? this.favorites,
      playlists: playlists ?? this.playlists,
    );
  }
}

class MusicController extends StateNotifier<MusicState> {
  MusicController(this._repo) : super(MusicState.initial()) {
    // 默认歌单
    state = state.copyWith(
      playlists: const [
        Playlist(id: 'p1', name: '缓解焦虑专题', trackIds: ['t6', 't2', 't8']),
        Playlist(id: 'p2', name: '舒缓助眠专题', trackIds: ['t1', 't5', 't3']),
      ],
    );
  }

  final MusicRepository _repo;

  void setQuery(String q) => state = state.copyWith(query: q);

  void toggleFavorite(String trackId) {
    final fav = {...state.favorites};
    if (fav.contains(trackId)) {
      fav.remove(trackId);
    } else {
      fav.add(trackId);
    }
    state = state.copyWith(favorites: fav);
  }

  void createPlaylist(String name) {
    final list = [...state.playlists, Playlist(id: 'p_${DateTime.now().millisecondsSinceEpoch}', name: name, trackIds: const [])];
    state = state.copyWith(playlists: list);
  }

  void addToPlaylist(String playlistId, String trackId) {
    final updated = state.playlists.map((p) {
      if (p.id != playlistId) return p;
      if (p.trackIds.contains(trackId)) return p;
      return p.copyWith(trackIds: [...p.trackIds, trackId]);
    }).toList();
    state = state.copyWith(playlists: updated);
  }

  List<Track> filteredTracks() {
    final q = state.query.trim().toLowerCase();
    if (q.isEmpty) return MusicRepository.tracks;
    return MusicRepository.tracks.where((t) {
      final s = '${t.title} ${t.artist} ${t.tags.join(' ')}'.toLowerCase();
      return s.contains(q);
    }).toList();
  }

  Track trackById(String id) => _repo.byId(id);
}

final musicRepositoryProvider = Provider<MusicRepository>((ref) => const MusicRepository());

final musicControllerProvider = StateNotifierProvider<MusicController, MusicState>((ref) {
  final repo = ref.watch(musicRepositoryProvider);
  return MusicController(repo);
});
