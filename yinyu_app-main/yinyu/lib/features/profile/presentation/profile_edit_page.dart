import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/validators.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../auth/models/user_profile.dart';
import '../../auth/state/auth_controller.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nickname;
  late TextEditingController _age;
  String _gender = '未设置';
  final Set<String> _tags = {};

  @override
  void initState() {
    super.initState();
    final p = ref.read(authStateProvider).profile!;
    _nickname = TextEditingController(text: p.nickname);
    _age = TextEditingController(text: p.age.toString());
    _gender = p.gender;
    _tags.addAll(p.tags);
  }

  @override
  void dispose() {
    _nickname.dispose();
    _age.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final auth = ref.read(authControllerProvider);
    final current = auth.state.profile!;
    final age = int.tryParse(_age.text.trim()) ?? current.age;

    final updated = current.copyWith(
      nickname: _nickname.text.trim(),
      age: age,
      gender: _gender,
      tags: _tags.toList(),
    );
    auth.updateProfile(updated);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('保存成功（演示）')));
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
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded)),
                Text('信息资料', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const Spacer(),
                FilledButton(onPressed: _save, child: const Text('保存')),
              ],
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nickname,
                    decoration: const InputDecoration(labelText: '昵称'),
                    validator: (v) => Validators.nonEmpty(v, label: '昵称'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _age,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: '年龄'),
                  ),
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('个人标签', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const ['助眠', '减压', '焦虑管理', '学习压力', '运动放松', '社交压力'].map((t) {
                      return _TagOption(tag: t);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagOption extends ConsumerWidget {
  final String tag;
  const _TagOption({required this.tag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = context.findAncestorStateOfType<_ProfileEditPageState>();
    final selected = page?._tags.contains(tag) ?? false;

    return FilterChip(
      label: Text(tag),
      selected: selected,
      onSelected: (_) {
        page?.setState(() {
          if (page._tags.contains(tag)) {
            page._tags.remove(tag);
          } else {
            page._tags.add(tag);
          }
        });
      },
    );
  }
}
