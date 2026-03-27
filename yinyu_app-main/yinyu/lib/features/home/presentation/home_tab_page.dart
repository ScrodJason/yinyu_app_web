import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/section_header.dart';
import '../../auth/state/auth_controller.dart';
import '../state/detection_controller.dart';
import '../state/music_controller.dart';
import '../state/meditation_controller.dart';

class HomeTabPage extends ConsumerWidget {
  const HomeTabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final nickname = auth.profile?.nickname ?? '你';
    final det = ref.watch(detectionControllerProvider);
    final music = ref.watch(musicControllerProvider);
    final meditation = ref.watch(meditationControllerProvider);

    final recentSession = det.sessions.isNotEmpty ? det.sessions.first : null;
    final recentMeditation = meditation.records.isNotEmpty ? meditation.records.first : null;

    final tracks = ref.read(musicControllerProvider.notifier).filteredTracks().take(4).toList();

    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const SizedBox(height: 6),
            Row(
              children: [
                Text('你好，$nickname', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const Spacer(),
                IconButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('演示版：通知/消息中心未接入后端。')),
                  ),
                  icon: const Icon(Icons.notifications_none_rounded),
                ),
              ],
            ),
            Text('今天也给自己一点温柔的时间。', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 14),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _FeatureCard(
                  title: '音愈检测',
                  subtitle: '模拟设备检测',
                  icon: Icons.sensors_rounded,
                  warm: true,
                  onTap: () => context.push('/detection'),
                ),
                _FeatureCard(
                  title: '音乐库',
                  subtitle: '收藏/专题/歌单',
                  icon: Icons.library_music_rounded,
                  onTap: () => context.push('/music'),
                ),
                _FeatureCard(
                  title: '冥想挑战',
                  subtitle: '15分钟打卡',
                  icon: Icons.self_improvement_rounded,
                  warm: true,
                  onTap: () => context.push('/meditation'),
                ),
                _FeatureCard(
                  title: '心理咨询',
                  subtitle: '咨询师/聊天',
                  icon: Icons.support_agent_rounded,
                  onTap: () => context.push('/consultation'),
                ),
              ],
            ),

            const SizedBox(height: 18),
            const SectionHeader(title: '你的今日状态'),
            const SizedBox(height: 10),
            AppCard(
              onTap: () => context.push('/detection'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.insights_rounded, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text('最近一次检测', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                      const Spacer(),
                      TextButton(onPressed: () => context.push('/detection'), child: const Text('去检测')),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (recentSession == null)
                    Text('暂无记录，点击开始一次音愈检测。', style: Theme.of(context).textTheme.bodyMedium)
                  else
                    Row(
                      children: [
                        Chip(label: Text(recentSession.emotionLabel)),
                        const SizedBox(width: 8),
                        Text('压力 ${(recentSession.stress * 100).round()}%', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(width: 12),
                        Text('唤醒 ${(recentSession.arousal * 100).round()}%', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  const SizedBox(height: 10),
                  if (recentMeditation != null)
                    Text('最近一次冥想：${recentMeditation.minutes} 分钟 · ${recentMeditation.preset}', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),

            const SizedBox(height: 18),
            const SectionHeader(title: '为你推荐'),
            const SizedBox(height: 10),
            ...tracks.map((t) {
              final fav = music.favorites.contains(t.id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  onTap: () => context.push('/music/player/${t.id}'),
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
                        onPressed: () => ref.read(musicControllerProvider.notifier).toggleFavorite(t.id),
                        icon: Icon(fav ? Icons.favorite_rounded : Icons.favorite_border_rounded),
                      )
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => context.push('/music'),
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('进入音乐库'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool warm;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.warm = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = warm ? const Color(0xFFFFB020) : scheme.primary;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              bg.withOpacity(0.18),
              scheme.primary.withOpacity(0.08),
              Colors.white.withOpacity(0.86),
            ],
          ),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: scheme.primary),
            const Spacer(),
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
