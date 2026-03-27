import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/gradient_background.dart';
import '../../state/consultation_controller.dart';

class ConsultChatPage extends ConsumerStatefulWidget {
  final String consultantId;
  const ConsultChatPage({super.key, required this.consultantId});

  @override
  ConsumerState<ConsultChatPage> createState() => _ConsultChatPageState();
}

class _ConsultChatPageState extends ConsumerState<ConsultChatPage> {
  final _input = TextEditingController();
  final _messages = <_Msg>[
    _Msg(fromMe: false, text: '你好，我是咨询师。你今天想聊什么？'),
    _Msg(fromMe: true, text: '最近压力有点大，睡眠也不太好。'),
    _Msg(fromMe: false, text: '明白。我们先从“压力来源”和“睡前习惯”两个方向梳理，可以吗？'),
  ];

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _send() {
    final s = _input.text.trim();
    if (s.isEmpty) return;
    setState(() {
      _messages.add(_Msg(fromMe: true, text: s));
      _input.clear();
      _messages.add(_Msg(fromMe: false, text: '收到。你愿意用 1-10 分给当前压力打个分吗？（演示回复）'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(consultantByIdProvider(widget.consultantId));
    return Scaffold(
      body: GradientBackground(
        withWarmAccent: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                        Text(c.title, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('演示版：通话/文件传输未接入。'))),
                    icon: const Icon(Icons.more_horiz_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _Bubble(m: _messages[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      decoration: const InputDecoration(hintText: '输入消息…'),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: _send,
                    child: const Icon(Icons.send_rounded),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
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
