import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/gradient_background.dart';
import '../state/community_controller.dart';

class ArticleDetailPage extends ConsumerStatefulWidget {
  final String articleId;
  const ArticleDetailPage({super.key, required this.articleId});

  @override
  ConsumerState<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends ConsumerState<ArticleDetailPage> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    final st = ref.watch(communityControllerProvider);
    final a = st.articles.firstWhere((e) => e.id == widget.articleId, orElse: () => st.articles.first);

    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded)),
                Text('音愈头条', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 8),
            Text(a.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text('${DateFormat('yyyy-MM-dd').format(a.at)} · ${a.views} 浏览 · ${a.comments} 评论', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white.withOpacity(0.92),
                border: Border.all(color: Colors.black.withOpacity(0.06)),
              ),
              child: const Text(
                '（演示内容）\n\n这里是文章正文区域。\n你可以在此接入真正的科普文章/研究动态等内容源，'
                '并展示发布时间、浏览量、评论、点赞、转发等数据。\n\n本 Demo 仅实现 UI 与简单交互。',
                style: TextStyle(height: 1.45),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: () => setState(() => _liked = !_liked),
                  icon: Icon(_liked ? Icons.favorite_rounded : Icons.favorite_border_rounded),
                  label: Text(_liked ? '已点赞' : '点赞'),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('演示版：评论编辑未接入。'))),
                  icon: const Icon(Icons.chat_bubble_outline_rounded),
                  label: const Text('评论'),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已转发（演示）'))),
                  icon: const Icon(Icons.ios_share_rounded),
                  label: const Text('转发'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
