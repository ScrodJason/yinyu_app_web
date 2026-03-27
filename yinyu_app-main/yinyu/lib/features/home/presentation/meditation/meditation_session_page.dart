import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../state/meditation_controller.dart';

class MeditationSessionPage extends ConsumerStatefulWidget {
  final int minutes;
  final String preset;

  const MeditationSessionPage({super.key, required this.minutes, required this.preset});

  @override
  ConsumerState<MeditationSessionPage> createState() => _MeditationSessionPageState();
}

class _MeditationSessionPageState extends ConsumerState<MeditationSessionPage> {
  Timer? _timer;
  late int _leftSec;
  bool _running = true;

  @override
  void initState() {
    super.initState();
    _leftSec = widget.minutes * 60;
    _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_running) return;
      setState(() {
        _leftSec--;
        if (_leftSec <= 0) {
          _leftSec = 0;
          _running = false;
          _timer?.cancel();
          ref.read(meditationControllerProvider.notifier).addRecord(minutes: widget.minutes, preset: widget.preset);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final left = Duration(seconds: _leftSec);
    final done = _leftSec == 0;

    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close_rounded)),
                Text('冥想进行中', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Text(widget.preset, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text('${widget.minutes} 分钟', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 18),
                  Text(
                    _fmt(left),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 18),
                  if (!done)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton(
                          onPressed: () => setState(() => _running = !_running),
                          style: FilledButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(18)),
                          child: Icon(_running ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 30),
                        ),
                        const SizedBox(width: 14),
                        OutlinedButton(
                          onPressed: () => setState(() => _leftSec = widget.minutes * 60),
                          child: const Text('重置'),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        const Icon(Icons.celebration_rounded, size: 40),
                        const SizedBox(height: 10),
                        Text('完成打卡！', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () {
                                  final prefill = Uri.encodeComponent('我刚完成 ${widget.minutes} 分钟冥想挑战（${widget.preset}），感觉更平静了。');
                                  context.go('/community/new-post?prefill=$prefill');
                                },
                                icon: const Icon(Icons.forum_rounded),
                                label: const Text('去社区分享'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => context.go('/meditation'),
                                child: const Text('返回'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  const SizedBox(height: 10),
                  Text('说明：此为计时与交互演示，不播放真实音频。', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '${two(m)}:${two(s)}';
  }
}
