import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/gradient_background.dart';
import '../state/profile_settings_controller.dart';

class SecurityPage extends ConsumerWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(profileSettingsProvider);
    final c = ref.read(profileSettingsProvider.notifier);

    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded)),
                Text('密码与安全', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 10),
            AppCard(
              child: Column(
                children: [
                  SwitchListTile(
                    value: s.securityNotify,
                    onChanged: c.setSecurityNotify,
                    title: const Text('安全通知'),
                    subtitle: const Text('账号异常时推送提醒（演示）'),
                    secondary: const Icon(Icons.notifications_active_outlined),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            AppCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.password_rounded),
                    title: const Text('修改密码'),
                    subtitle: const Text('演示入口（未接入后端）'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('演示版：修改密码未接入。'))),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: s.twoFactorSms,
                    onChanged: c.set2faSms,
                    title: const Text('双重认证：短信'),
                    subtitle: const Text('通过手机短信二次验证'),
                    secondary: const Icon(Icons.sms_outlined),
                  ),
                  SwitchListTile(
                    value: s.twoFactorEmail,
                    onChanged: c.set2faEmail,
                    title: const Text('双重认证：邮箱'),
                    subtitle: const Text('通过邮箱二次验证'),
                    secondary: const Icon(Icons.email_outlined),
                  ),
                  SwitchListTile(
                    value: s.twoFactorThirdParty,
                    onChanged: c.set2faThirdParty,
                    title: const Text('双重认证：第三方'),
                    subtitle: const Text('例如认证器 App（演示）'),
                    secondary: const Icon(Icons.verified_user_outlined),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '提示：文档描述安全模块可发送安全通知并支持双重认证（短信/邮箱/第三方）。本 Demo 已提供对应开关与交互。',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
