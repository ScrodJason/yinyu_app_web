import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/section_header.dart';
import '../../state/meditation_controller.dart';

class MeditationPage extends ConsumerStatefulWidget {
  const MeditationPage({super.key});

  @override
  ConsumerState<MeditationPage> createState() => _MeditationPageState();
}

class _MeditationPageState extends ConsumerState<MeditationPage> {
  int _minutes = 15;
  String _preset = '雨声';

  @override
  Widget build(BuildContext context) {
    final st = ref.watch(meditationControllerProvider);
    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded)),
                Text('冥想挑战', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: '开始一次冥想'),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    value: _minutes,
                    decoration: const InputDecoration(labelText: '时长（分钟）'),
                    items: const [
                      DropdownMenuItem(value: 5, child: Text('5')),
                      DropdownMenuItem(value: 10, child: Text('10')),
                      DropdownMenuItem(value: 15, child: Text('15（推荐）')),
                      DropdownMenuItem(value: 20, child: Text('20')),
                    ],
                    onChanged: (v) => setState(() => _minutes = v ?? 15),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _preset,
                    decoration: const InputDecoration(labelText: '引导音景'),
                    items: const [
                      DropdownMenuItem(value: '雨声', child: Text('雨声')),
                      DropdownMenuItem(value: '海浪', child: Text('海浪')),
                      DropdownMenuItem(value: '白噪音', child: Text('白噪音')),
                      DropdownMenuItem(value: '治愈钢琴', child: Text('治愈钢琴')),
                    ],
                    onChanged: (v) => setState(() => _preset = v ?? '雨声'),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => context.push('/meditation/session?mins=$_minutes&preset=$_preset'),
                      icon: const Icon(Icons.self_improvement_rounded),
                      label: const Text('开始冥想'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('文档描述：冥想挑战用于放松减压、改善睡眠与情绪管理，本 Demo 仅做流程演示。', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: '打卡记录'),
            const SizedBox(height: 10),
            if (st.records.isEmpty)
              AppCard(child: Text('暂无打卡记录', style: Theme.of(context).textTheme.bodyMedium))
            else
              ...st.records.take(10).map((r) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    child: ListTile(
                      leading: const Icon(Icons.check_circle_outline_rounded),
                      title: Text('${r.minutes} 分钟 · ${r.preset}'),
                      subtitle: Text(DateFormat('MM-dd HH:mm').format(r.at)),
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
