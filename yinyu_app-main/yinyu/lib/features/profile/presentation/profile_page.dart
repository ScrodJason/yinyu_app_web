import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../auth/state/auth_controller.dart';
import '../state/profile_settings_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final settings = ref.watch(profileSettingsProvider);

    final profile = auth.profile;

    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text('我的', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),

            AppCard(
              onTap: () => context.push('/profile/edit'),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 26,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                  child: const Icon(Icons.person_rounded),
                ),
                title: Text(profile?.nickname ?? '用户', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                subtitle: Text('${profile?.phone ?? ''} · ${settings.memberPlan}'),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
            ),

            const SizedBox(height: 14),
            AppCard(
              child: Column(
                children: [
                  SwitchListTile(
                    value: settings.remindMeditation,
                    onChanged: (v) => ref.read(profileSettingsProvider.notifier).setRemindMeditation(v),
                    title: const Text('每日冥想任务提醒'),
                    subtitle: const Text('可帮助你坚持打卡'),
                    secondary: const Icon(Icons.alarm_rounded),
                  ),
                  SwitchListTile(
                    value: settings.remindDetection,
                    onChanged: (v) => ref.read(profileSettingsProvider.notifier).setRemindDetection(v),
                    title: const Text('音愈检测提醒'),
                    subtitle: const Text('按计划做情绪监测（演示）'),
                    secondary: const Icon(Icons.sensors_rounded),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            AppCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.workspace_premium_outlined),
                    title: const Text('会员中心'),
                    subtitle: Text(settings.isMember ? '当前：${settings.memberPlan}' : '未开通'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/profile/membership'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.support_agent_rounded),
                    title: const Text('联系客服 / 意见反馈'),
                    subtitle: const Text('支持文字/图片/文件（演示入口）'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/profile/support'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security_rounded),
                    title: const Text('密码与安全'),
                    subtitle: const Text('安全通知与双重认证（演示）'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/profile/security'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () {
                ref.read(authControllerProvider).signOut();
                context.go('/login');
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('退出登录'),
            ),
            const SizedBox(height: 8),
            Text(
              '说明：文档中“我的”包含个人账户、会员中心、客服、密码与安全等模块；本 Demo 全部给出 UI 与简单交互。',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
