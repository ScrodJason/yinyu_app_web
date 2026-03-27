import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/validators.dart';
import '../../../core/widgets/gradient_background.dart';
import '../models/user_profile.dart';
import '../state/auth_controller.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  int _step = 0;

  final _nickname = TextEditingController(text: '新用户');
  final _age = TextEditingController(text: '20');
  String _gender = '未设置';

  final Set<String> _tags = {'助眠', '减压'};
  final Set<String> _musicPrefs = {'白噪音', '自然音景'};

  // 简化版“抑郁状况评估”（不做医学判断，仅用于演示）
  final _q = <String>[
    '最近两周是否经常感到情绪低落？',
    '最近两周是否经常对事物失去兴趣？',
    '是否存在入睡困难或睡眠质量差？',
    '是否容易感到疲惫、精力不足？',
  ];
  final _a = <int>[0, 0, 0, 0]; // 0=从不 1=偶尔 2=经常 3=几乎每天

  @override
  void dispose() {
    _nickname.dispose();
    _age.dispose();
    super.dispose();
  }

  int get _score => _a.fold(0, (p, c) => p + c);

  String get _scoreLabel {
    final s = _score;
    if (s <= 3) return '积极/稳定';
    if (s <= 6) return '轻度波动';
    if (s <= 9) return '需要关注';
    return '建议寻求专业支持';
  }

  void _finish() {
    final auth = ref.read(authControllerProvider);
    final current = auth.state.profile!;
    final age = int.tryParse(_age.text.trim()) ?? 20;

    final profile = current.copyWith(
      nickname: _nickname.text.trim().isEmpty ? current.nickname : _nickname.text.trim(),
      age: age,
      gender: _gender,
      tags: _tags.toList(),
    );
    auth.completeOnboarding(profile);
    context.go('/app');
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          children: [
            Row(
              children: [
                Text('首次登录问卷', style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const Spacer(),
                TextButton(
                  onPressed: () => _finish(),
                  child: const Text('跳过'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('用于收集基础信息与习惯偏好，帮助优化体验与推荐。', style: t.bodyMedium),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Stepper(
                  currentStep: _step,
                  physics: const NeverScrollableScrollPhysics(),
                  onStepContinue: () {
                    if (_step < 2) {
                      setState(() => _step++);
                    } else {
                      _finish();
                    }
                  },
                  onStepCancel: () {
                    if (_step > 0) setState(() => _step--);
                  },
                  controlsBuilder: (context, details) {
                    final isLast = _step == 2;
                    return Row(
                      children: [
                        FilledButton(
                          onPressed: details.onStepContinue,
                          child: Text(isLast ? '完成' : '下一步'),
                        ),
                        const SizedBox(width: 10),
                        if (_step > 0)
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('上一步'),
                          ),
                      ],
                    );
                  },
                  steps: [
                    Step(
                      title: const Text('基础信息'),
                      isActive: _step >= 0,
                      content: Column(
                        children: [
                          TextFormField(
                            controller: _nickname,
                            decoration: const InputDecoration(labelText: '昵称'),
                            validator: (v) => Validators.nonEmpty(v, label: '昵称'),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _age,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: '年龄'),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _gender,
                            items: const [
                              DropdownMenuItem(value: '未设置', child: Text('未设置')),
                              DropdownMenuItem(value: '男', child: Text('男')),
                              DropdownMenuItem(value: '女', child: Text('女')),
                              DropdownMenuItem(value: '其他', child: Text('其他')),
                            ],
                            onChanged: (v) => setState(() => _gender = v ?? '未设置'),
                            decoration: const InputDecoration(labelText: '性别'),
                          ),
                          const SizedBox(height: 10),
                          _MultiChip(
                            title: '个人标签（示例）',
                            options: const ['助眠', '减压', '焦虑管理', '学习压力', '运动放松', '社交压力'],
                            selected: _tags,
                            onToggle: (s) => setState(() {
                              if (_tags.contains(s)) {
                                _tags.remove(s);
                              } else {
                                _tags.add(s);
                              }
                            }),
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text('偏好与习惯'),
                      isActive: _step >= 1,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _MultiChip(
                            title: '偏好音乐类型（示例）',
                            options: const ['白噪音', '自然音景', '治愈系', '放松类', '冥想专用', '轻音乐'],
                            selected: _musicPrefs,
                            onToggle: (s) => setState(() {
                              if (_musicPrefs.contains(s)) {
                                _musicPrefs.remove(s);
                              } else {
                                _musicPrefs.add(s);
                              }
                            }),
                          ),
                          const SizedBox(height: 10),
                          SwitchListTile(
                            value: true,
                            onChanged: (_) {},
                            title: const Text('允许生成“每日冥想任务”提醒'),
                            subtitle: const Text('可在“我的 > 通知提醒”里随时关闭'),
                          ),
                          SwitchListTile(
                            value: true,
                            onChanged: (_) {},
                            title: const Text('允许“音愈检测”提醒'),
                            subtitle: const Text('可在“我的 > 通知提醒”里随时关闭'),
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text('简易情绪评估'),
                      isActive: _step >= 2,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('仅用于演示页面与交互，不替代任何医学诊断。', style: t.bodySmall),
                          const SizedBox(height: 8),
                          ...List.generate(_q.length, (i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _Question(
                                title: _q[i],
                                value: _a[i],
                                onChanged: (v) => setState(() => _a[i] = v),
                              ),
                            );
                          }),
                          const Divider(),
                          Row(
                            children: [
                              Text('评估结果：', style: t.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(width: 6),
                              Chip(label: Text(_scoreLabel)),
                              const Spacer(),
                              Text('得分 $_score', style: t.bodySmall),
                            ],
                          )
                        ],
                      ),
                    ),
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

class _MultiChip extends StatelessWidget {
  final String title;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const _MultiChip({required this.title, required this.options, required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: t.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((o) {
            final isOn = selected.contains(o);
            return FilterChip(
              selected: isOn,
              onSelected: (_) => onToggle(o),
              label: Text(o),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _Question extends StatelessWidget {
  final String title;
  final int value;
  final ValueChanged<int> onChanged;
  const _Question({required this.title, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final options = const ['从不', '偶尔', '经常', '几乎每天'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          children: List.generate(options.length, (i) {
            return ChoiceChip(
              label: Text(options[i]),
              selected: value == i,
              onSelected: (_) => onChanged(i),
            );
          }),
        ),
      ],
    );
  }
}
