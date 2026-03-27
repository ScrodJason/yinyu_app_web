import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/section_header.dart';
import '../../state/music_controller.dart';

class MusicLibraryPage extends ConsumerWidget {
  const MusicLibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(musicControllerProvider);
    final ctrl = ref.read(musicControllerProvider.notifier);
    final tracks = ctrl.filteredTracks();
    final favorites = tracks.where((t) => st.favorites.contains(t.id)).toList();

    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded)),
                Text('音乐库', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const Spacer(),
                IconButton(
                  onPressed: () => _createPlaylistDialog(context, ref),
                  icon: const Icon(Icons.playlist_add_rounded),
                  tooltip: '创建歌单',
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: ctrl.setQuery,
              decoration: const InputDecoration(
                hintText: '搜索：治愈系 / 白噪音 / 助眠 / 冥想…',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 14),

            const SectionHeader(title: '专题与歌单'),
            const SizedBox(height: 10),
            SizedBox(
              height: 112,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: st.playlists.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  final p = st.playlists[i];
                  return SizedBox(
                    width: 220,
                    child: AppCard(
                      onTap: () => _openPlaylist(context, ref, p.id),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 6),
                          Text('${p.trackIds.length} 首', style: Theme.of(context).textTheme.bodySmall),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: OutlinedButton.icon(
                              onPressed: () => _openPlaylist(context, ref, p.id),
                              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                              label: const Text('打开'),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            const SectionHeader(title: '我的收藏'),
            const SizedBox(height: 10),
            if (favorites.isEmpty)
              AppCard(child: Text('暂无收藏（点击心形即可收藏）', style: Theme.of(context).textTheme.bodyMedium))
            else
              ...favorites.map((t) => _TrackRow(trackId: t.id)),

            const SizedBox(height: 16),
            const SectionHeader(title: '全部音乐'),
            const SizedBox(height: 10),
            ...tracks.map((t) => _TrackRow(trackId: t.id)),
            const SizedBox(height: 8),
            Text(
              '提示：文档提到音乐库包含收藏、专题、自创歌单、以及 CC0 版权曲库等内容；本 Demo 仅做 UI/交互演示。',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createPlaylistDialog(BuildContext context, WidgetRef ref) async {
    final nameCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('创建歌单'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: '歌单名称'),
              validator: (v) => Validators.nonEmpty(v, label: '歌单名称'),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
            FilledButton(
              onPressed: () {
                if (!(formKey.currentState?.validate() ?? false)) return;
                ref.read(musicControllerProvider.notifier).createPlaylist(nameCtrl.text.trim());
                Navigator.pop(context);
              },
              child: const Text('创建'),
            ),
          ],
        );
      },
    );
  }

  void _openPlaylist(BuildContext context, WidgetRef ref, String playlistId) {
    final st = ref.read(musicControllerProvider);
    final p = st.playlists.firstWhere((e) => e.id == playlistId);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(p.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              if (p.trackIds.isEmpty)
                const ListTile(
                  leading: Icon(Icons.queue_music_rounded),
                  title: Text('歌单为空'),
                  subtitle: Text('在“全部音乐”里点“添加到歌单”即可。'),
                )
              else
                ...p.trackIds.map((id) => _TrackRow(trackId: id)),
            ],
          ),
        );
      },
    );
  }
}

class _TrackRow extends ConsumerWidget {
  final String trackId;
  const _TrackRow({required this.trackId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(musicControllerProvider.notifier);
    final st = ref.watch(musicControllerProvider);
    final t = ctrl.trackById(trackId);
    final fav = st.favorites.contains(trackId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: () => context.push('/music/player/$trackId'),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
              ),
              child: const Icon(Icons.music_note_rounded),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text('${t.artist} · ${t.tags.take(2).join(' / ')}', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            IconButton(
              onPressed: () => ref.read(musicControllerProvider.notifier).toggleFavorite(trackId),
              icon: Icon(fav ? Icons.favorite_rounded : Icons.favorite_border_rounded),
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v.startsWith('pl:')) {
                  final pid = v.substring(3);
                  ref.read(musicControllerProvider.notifier).addToPlaylist(pid, trackId);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已添加到歌单')));
                }
              },
              itemBuilder: (_) {
                final playlists = st.playlists;
                return [
                  const PopupMenuItem(value: 'noop', enabled: false, child: Text('添加到歌单')),
                  ...playlists.map((p) => PopupMenuItem(value: 'pl:${p.id}', child: Text(p.name))),
                ];
              },
              icon: const Icon(Icons.more_vert_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
