import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/section_header.dart';
import '../../state/detection_controller.dart';
import 'sparkline.dart';

class DetectionPage extends ConsumerWidget {
  const DetectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(detectionControllerProvider);
    final ctrl = ref.read(detectionControllerProvider.notifier);
    final recent = st.sessions.isNotEmpty ? st.sessions.first : null;

    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded)),
                Text('音愈检测', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: '设备状态'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(st.deviceConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(st.deviceConnected ? '已连接（演示）' : '未连接', style: Theme.of(context).textTheme.bodyMedium),
                      const Spacer(),
                      OutlinedButton(
                        onPressed: ctrl.toggleDevice,
                        child: Text(st.deviceConnected ? '断开' : '连接'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: st.deviceConnected
                        ? () {
                            final s = ctrl.runMockDetection();
                            final snack = SnackBar(content: Text('检测完成：${s.emotionLabel} · 推送适配音乐（演示）'));
                            ScaffoldMessenger.of(context).showSnackBar(snack);
                          }
                        : null,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('开始检测（模拟）'),
                  ),
                  const SizedBox(height: 6),
                  Text('说明：此页面仅模拟“监测实时化、数据记录、数据分析与推送音乐”的交互流程。', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: 14),

            const SectionHeader(title: '检测结果'),
            const SizedBox(height: 10),
            AppCard(
              onTap: recent == null ? null : () => context.push('/music?from=detection'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (recent == null) ...[
                    Text('暂无检测记录。连接设备后开始一次检测。', style: Theme.of(context).textTheme.bodyMedium),
                  ] else ...[
                    Row(
                      children: [
                        Chip(label: Text(recent.emotionLabel)),
                        const SizedBox(width: 8),
                        Text(DateFormat('MM-dd HH:mm').format(recent.at), style: Theme.of(context).textTheme.bodySmall),
                        const Spacer(),
                        TextButton(onPressed: () => context.push('/music?from=detection'), child: const Text('去听推荐')),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Sparkline(values: recent.sparkline),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _Metric(label: '压力', value: '${(recent.stress * 100).round()}%')),
                        const SizedBox(width: 10),
                        Expanded(child: _Metric(label: '唤醒度', value: '${(recent.arousal * 100).round()}%')),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            const SectionHeader(title: '历史记录'),
            const SizedBox(height: 10),
            if (st.sessions.isEmpty)
              AppCard(child: Text('暂无记录', style: Theme.of(context).textTheme.bodyMedium))
            else
              ...st.sessions.take(10).map((s) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    onTap: () => context.push('/music?from=detection'),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                          ),
                          child: const Icon(Icons.monitor_heart_rounded),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.emotionLabel, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 2),
                              Text(DateFormat('MM-dd HH:mm').format(s.at), style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                        Text('${(s.stress * 100).round()}%', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: t.bodySmall),
          const SizedBox(height: 4),
          Text(value, style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
