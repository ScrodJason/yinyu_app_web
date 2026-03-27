import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/validators.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../auth/state/auth_controller.dart';
import '../state/community_controller.dart';

class NewPostPage extends ConsumerStatefulWidget {
  final String? prefill;
  const NewPostPage({super.key, this.prefill});

  @override
  ConsumerState<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends ConsumerState<NewPostPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _content;

  final Set<String> _tags = {'心情记录'};

  @override
  void initState() {
    super.initState();
    _content = TextEditingController(text: widget.prefill ?? '');
  }

  @override
  void dispose() {
    _content.dispose();
    super.dispose();
  }

  void _publish() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final author = ref.read(authStateProvider).profile?.nickname ?? '音友';
    ref.read(communityControllerProvider.notifier).addPost(
          author: author,
          content: '${_content.text.trim()}\n#${_tags.join(' #')}',
        );
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('发布成功（演示）')));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close_rounded)),
                Text('发布动态', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const Spacer(),
                FilledButton(onPressed: _publish, child: const Text('发布')),
              ],
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _content,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: '分享你的心情、冥想打卡、音乐感受…',
                ),
                validator: (v) => Validators.nonEmpty(v, label: '内容'),
              ),
            ),
            const SizedBox(height: 12),
            Text('添加话题', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const ['心情记录', '冥想打卡', '减压', '助眠', '学习压力', '焦虑管理'].map((t) {
                return _TagChip(tag: t);
              }).toList(),
            ),
            const SizedBox(height: 12),
            Text('提示：文档描述动态支持点赞/评论/转发与搜索，本 Demo 已在社区页实现。', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends ConsumerWidget {
  final String tag;
  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 为简化，这里不做全局 tag 管理；仅 UI 展示
    return FilterChip(
      label: Text(tag),
      selected: false,
      onSelected: (_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('已选择话题：$tag（演示）')));
      },
    );
  }
}
