import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/gradient_background.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _input = TextEditingController();
  final _feedback = TextEditingController();
  final _msgs = <_Msg>[
    _Msg(fromMe: false, text: '你好，我是音愈客服。有什么可以帮你？'),
    _Msg(fromMe: true, text: '我想了解会员权益。'),
    _Msg(fromMe: false, text: '会员可解锁更多专题内容与优先接入客服（演示回复）。'),
  ];

  @override
  void dispose() {
    _input.dispose();
    _feedback.dispose();
    super.dispose();
  }

  void _send() {
    final s = _input.text.trim();
    if (s.isEmpty) return;
    setState(() {
      _msgs.add(_Msg(fromMe: true, text: s));
      _input.clear();
      _msgs.add(_Msg(fromMe: false, text: '已收到，我们会尽快处理（演示）。'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: GradientBackground(
          withWarmAccent: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: [
                    IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded)),
                    Text('客服与反馈', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              const TabBar(tabs: [Tab(text: '在线客服'), Tab(text: '意见反馈')]),
              const SizedBox(height: 6),
              Expanded(
                child: TabBarView(
                  children: [
                    _chatView(context),
                    _feedbackView(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chatView(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            itemCount: _msgs.length,
            itemBuilder: (_, i) => _Bubble(m: _msgs[i]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Row(
            children: [
              IconButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('演示版：图片/文件附件未接入。'))),
                icon: const Icon(Icons.attach_file_rounded),
              ),
              Expanded(
                child: TextField(
                  controller: _input,
                  decoration: const InputDecoration(hintText: '输入消息…'),
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(width: 10),
              FilledButton(onPressed: _send, child: const Icon(Icons.send_rounded)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _feedbackView(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text('提交问题或建议（演示）', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        TextField(
          controller: _feedback,
          maxLines: 6,
          decoration: const InputDecoration(hintText: '例如：页面卡顿、功能建议、账号异常…'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已选择附件（演示）'))),
          icon: const Icon(Icons.image_outlined),
          label: const Text('添加图片/文件'),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('反馈已提交（演示）'))),
          child: const Text('提交'),
        ),
        const SizedBox(height: 10),
        Text('提示：文档中客服支持文字、图片、文件传输，并提供售后/账户异常等通道；本 Demo 提供入口与交互占位。', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _Msg {
  final bool fromMe;
  final String text;
  const _Msg({required this.fromMe, required this.text});
}

class _Bubble extends StatelessWidget {
  final _Msg m;
  const _Bubble({required this.m});

  @override
  Widget build(BuildContext context) {
    final bg = m.fromMe ? Theme.of(context).colorScheme.primary.withOpacity(0.18) : Colors.white.withOpacity(0.92);
    final align = m.fromMe ? Alignment.centerRight : Alignment.centerLeft;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(m.fromMe ? 16 : 4),
      bottomRight: Radius.circular(m.fromMe ? 4 : 16),
    );

    return Align(
      alignment: align,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: radius,
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Text(m.text),
      ),
    );
  }
}
