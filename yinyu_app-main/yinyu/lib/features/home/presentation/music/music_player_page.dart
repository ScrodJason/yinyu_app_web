import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/gradient_background.dart';
import '../../state/music_controller.dart';
import '../../state/music_models.dart';

class MusicPlayerPage extends ConsumerStatefulWidget {
  final String trackId;
  const MusicPlayerPage({super.key, required this.trackId});

  @override
  ConsumerState<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends ConsumerState<MusicPlayerPage> {
  Timer? _timer;
  bool _playing = false;
  Duration _pos = Duration.zero;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlay(Duration total) {
    setState(() => _playing = !_playing);
    _timer?.cancel();
    if (_playing) {
      _timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
        setState(() {
          _pos += const Duration(milliseconds: 300);
          if (_pos >= total) {
            _pos = total;
            _playing = false;
            _timer?.cancel();
          }
        });
      });
    }
  }

  void _seek(Duration v) {
    setState(() => _pos = v);
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(musicControllerProvider.notifier);
    final st = ref.watch(musicControllerProvider);
    final Track track = ctrl.trackById(widget.trackId);

    final fav = st.favorites.contains(track.id);
    final total = track.duration;

    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded)),
                Text('播放', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const Spacer(),
                IconButton(
                  onPressed: () => ref.read(musicControllerProvider.notifier).toggleFavorite(track.id),
                  icon: Icon(fav ? Icons.favorite_rounded : Icons.favorite_border_rounded),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.22),
                      const Color(0xFFFFB020).withOpacity(0.14),
                      Colors.white.withOpacity(0.90),
                    ],
                  ),
                  border: Border.all(color: Colors.black.withOpacity(0.06)),
                ),
                child: const Icon(Icons.album_rounded, size: 78),
              ),
            ),
            const SizedBox(height: 14),
            Text(track.title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(track.artist, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: track.tags.map((e) => Chip(label: Text(e))).toList(),
            ),
            const SizedBox(height: 18),

            _ProgressBar(
              position: _pos,
              total: total,
              onSeek: _seek,
            ),
            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _seek(Duration.zero),
                  icon: const Icon(Icons.skip_previous_rounded),
                  iconSize: 30,
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: () => _togglePlay(total),
                  style: FilledButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(18)),
                  child: Icon(_playing ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 30),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () => _seek(total),
                  icon: const Icon(Icons.skip_next_rounded),
                  iconSize: 30,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showAddToPlaylist(context, ref, track.id),
                    icon: const Icon(Icons.playlist_add_rounded),
                    label: const Text('加入歌单'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/music'),
                    icon: const Icon(Icons.library_music_rounded),
                    label: const Text('返回音乐库'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('说明：此播放页为“页面展示+简单交互”演示，进度条为模拟计时，不播放真实音频。', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  void _showAddToPlaylist(BuildContext context, WidgetRef ref, String trackId) {
    final st = ref.read(musicControllerProvider);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('选择歌单', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              ...st.playlists.map((p) {
                return ListTile(
                  leading: const Icon(Icons.queue_music_rounded),
                  title: Text(p.name),
                  subtitle: Text('${p.trackIds.length} 首'),
                  onTap: () {
                    ref.read(musicControllerProvider.notifier).addToPlaylist(p.id, trackId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已添加到歌单')));
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final Duration position;
  final Duration total;
  final ValueChanged<Duration> onSeek;
  const _ProgressBar({required this.position, required this.total, required this.onSeek});

  @override
  Widget build(BuildContext context) {
    final posMs = position.inMilliseconds.clamp(0, total.inMilliseconds);
    final tMs = total.inMilliseconds == 0 ? 1 : total.inMilliseconds;

    return Column(
      children: [
        Slider(
          value: posMs.toDouble(),
          min: 0,
          max: tMs.toDouble(),
          onChanged: (v) => onSeek(Duration(milliseconds: v.round())),
        ),
        Row(
          children: [
            Text(_fmt(position), style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            Text(_fmt(total), style: Theme.of(context).textTheme.bodySmall),
          ],
        )
      ],
    );
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '${two(m)}:${two(s)}';
  }
}
