import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../state/consultation_controller.dart';

class ConsultantDetailPage extends ConsumerStatefulWidget {
  final String consultantId;
  const ConsultantDetailPage({super.key, required this.consultantId});

  @override
  ConsumerState<ConsultantDetailPage> createState() => _ConsultantDetailPageState();
}

class _ConsultantDetailPageState extends ConsumerState<ConsultantDetailPage> {
  String _plan = '单次咨询（30分钟）';

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(consultantByIdProvider(widget.consultantId));
    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded)),
                Text('咨询详情', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 10),
            AppCard(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 26,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                  child: const Icon(Icons.person_rounded),
                ),
                title: Text(c.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                subtitle: Text('${c.title}\n擅长：${c.specialties.join(' / ')}'),
                isThreeLine: true,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.star_rounded, size: 16),
                      Text('${c.rating}'),
                    ]),
                    const SizedBox(height: 4),
                    Text('${c.cases}+案例', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            AppCard(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('选择套餐（演示）', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _plan,
                      items: const [
                        DropdownMenuItem(value: '单次咨询（30分钟）', child: Text('单次咨询（30分钟）')),
                        DropdownMenuItem(value: '单次咨询（60分钟）', child: Text('单次咨询（60分钟）')),
                        DropdownMenuItem(value: '长期咨询（月度）', child: Text('长期咨询（月度）')),
                        DropdownMenuItem(value: '团体咨询（定制）', child: Text('团体咨询（定制）')),
                      ],
                      onChanged: (v) => setState(() => _plan = v ?? _plan),
                      decoration: const InputDecoration(labelText: '套餐'),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('已选择：$_plan（演示，不扣费）')));
                          context.push('/consultation/chat/${c.id}');
                        },
                        icon: const Icon(Icons.chat_rounded),
                        label: const Text('进入咨询聊天'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('提示：文档中咨询包含服务提供、咨询师管理与多种收费模式；此处只做 UI/交互模拟。', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
