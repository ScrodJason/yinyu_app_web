import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/section_header.dart';
import '../state/community_controller.dart';

class CommunityPage extends ConsumerWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: GradientBackground(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    Text('社区', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    const Spacer(),
                    IconButton(
                      onPressed: () => context.push('/community/new-post'),
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      tooltip: '发布动态',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: '搜索动态 / 话题 / 头条…',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                  onChanged: (v) => ref.read(communityControllerProvider.notifier).setQuery(v),
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(text: '音愈动态'),
                  Tab(text: '视频推荐'),
                  Tab(text: '音愈头条'),
                ],
              ),
              const SizedBox(height: 6),
              Expanded(
                child: TabBarView(
                  children: [
                    _FeedTab(),
                    _VideoTab(),
                    _HeadlineTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedTab extends ConsumerWidget {
  const _FeedTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(communityControllerProvider);
    final q = st.query.trim().toLowerCase();
    final posts = q.isEmpty
        ? st.posts
        : st.posts.where((p) => ('${p.author} ${p.content}').toLowerCase().contains(q)).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      children: [
        const SectionHeader(title: '音友圈 · 打卡'),
        const SizedBox(height: 10),
        SizedBox(
          height: 112,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: st.circles.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final c = st.circles[i];
              return SizedBox(
                width: 230,
                child: AppCard(
                  onTap: () {
                    ref.read(communityControllerProvider.notifier).checkin(c.id);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('打卡成功（演示）')));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text('${c.members} 人 · 今日打卡 ${c.todayCheckins}', style: Theme.of(context).textTheme.bodySmall),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ref.read(communityControllerProvider.notifier).checkin(c.id);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('打卡成功（演示）')));
                          },
                          icon: const Icon(Icons.check_rounded, size: 16),
                          label: const Text('打卡'),
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
        const SectionHeader(title: '优质动态'),
        const SizedBox(height: 10),
        ...posts.map((p) => _PostCard(postId: p.id)),
      ],
    );
  }
}

class _PostCard extends ConsumerWidget {
  final String postId;
  const _PostCard({required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(communityControllerProvider);
    final p = st.posts.firstWhere((e) => e.id == postId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                  child: const Icon(Icons.person_rounded),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.author, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                      Text(DateFormat('MM-dd HH:mm').format(p.at), style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('演示版：举报/拉黑未接入。'))),
                  icon: const Icon(Icons.more_horiz_rounded),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(p.content, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  onPressed: () => ref.read(communityControllerProvider.notifier).toggleLike(p.id),
                  icon: Icon(p.liked ? Icons.favorite_rounded : Icons.favorite_border_rounded),
                ),
                Text('${p.likes}'),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('演示版：评论输入未展开。'))),
                  icon: const Icon(Icons.chat_bubble_outline_rounded),
                ),
                Text('${p.comments}'),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () => ref.read(communityControllerProvider.notifier).share(p.id),
                  icon: const Icon(Icons.ios_share_rounded),
                ),
                Text('${p.shares}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoTab extends ConsumerStatefulWidget {
  const _VideoTab();

  @override
  ConsumerState<_VideoTab> createState() => _VideoTabState();
}

class _VideoTabState extends ConsumerState<_VideoTab> {
  String _topic = '全部';

  @override
  Widget build(BuildContext context) {
    final st = ref.watch(communityControllerProvider);
    final q = st.query.trim().toLowerCase();
    final topics = ['全部', ...{for (final v in st.videos) v.topic}];
    final list = st.videos.where((v) {
      final hitTopic = _topic == '全部' || v.topic == _topic;
      final hitQuery = q.isEmpty || v.title.toLowerCase().contains(q) || v.topic.toLowerCase().contains(q);
      return hitTopic && hitQuery;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      children: [
        const SectionHeader(title: '话题'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: topics.map((t) {
            final on = _topic == t;
            return ChoiceChip(
              label: Text(t),
              selected: on,
              onSelected: (_) => setState(() => _topic = t),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const SectionHeader(title: '推荐视频'),
        const SizedBox(height: 10),
        ...list.map((v) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              onTap: () => context.push('/community/video/${v.id}'),
              child: ListTile(
                leading: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                  ),
                  child: const Icon(Icons.play_circle_outline_rounded),
                ),
                title: Text(v.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                subtitle: Text(v.topic),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.favorite_rounded, size: 16),
                  const SizedBox(width: 4),
                  Text('${v.likes}'),
                ]),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _HeadlineTab extends ConsumerWidget {
  const _HeadlineTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(communityControllerProvider);
    final q = st.query.trim().toLowerCase();
    final list = q.isEmpty
        ? st.articles
        : st.articles.where((a) => a.title.toLowerCase().contains(q)).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      children: [
        const SectionHeader(title: '精选头条'),
        const SizedBox(height: 10),
        ...list.map((a) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              onTap: () => context.push('/community/article/${a.id}'),
              child: ListTile(
                leading: const Icon(Icons.article_outlined),
                title: Text(a.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                subtitle: Text('${DateFormat('MM-dd').format(a.at)} · ${a.views} 浏览 · ${a.comments} 评论'),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        Text(
          '说明：文档描述“音愈头条”支持搜索、发布时间/浏览量/评论展示、以及点赞评论转发；本 Demo 在文章详情页提供互动按钮。',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
