import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/gradient_background.dart';
import '../state/community_controller.dart';

class VideoDetailPage extends ConsumerStatefulWidget {
  final String videoId;
  const VideoDetailPage({super.key, required this.videoId});

  @override
  ConsumerState<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends ConsumerState<VideoDetailPage> {
  bool _playing = false;
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    final st = ref.watch(communityControllerProvider);
    final v = st.videos.firstWhere((e) => e.id == widget.videoId, orElse: () => st.videos.first);

    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded)),
                Text('视频推荐', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 210,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.black.withOpacity(0.08),
                border: Border.all(color: Colors.black.withOpacity(0.06)),
              ),
              child: Center(
                child: FilledButton(
                  onPressed: () => setState(() => _playing = !_playing),
                  style: FilledButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(18)),
                  child: Icon(_playing ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 30),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(v.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text('话题：${v.topic}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 14),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: () => setState(() => _liked = !_liked),
                  icon: Icon(_liked ? Icons.favorite_rounded : Icons.favorite_border_rounded),
                  label: Text(_liked ? '已喜欢' : '喜欢'),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已分享（演示）'))),
                  icon: const Icon(Icons.ios_share_rounded),
                  label: const Text('分享'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('说明：此页面仅为短视频展示占位。可自行接入真实播放器与内容源。', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
