import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/mock_payment_flow.dart';
import '../state/profile_settings_controller.dart';

class MembershipPage extends ConsumerWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(profileSettingsProvider);

    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded)),
                Text('会员中心', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 10),
            AppCard(
              child: ListTile(
                leading: const Icon(Icons.workspace_premium_outlined),
                title: Text(s.isMember ? '已开通会员' : '未开通会员', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                subtitle: Text('当前套餐：${s.memberPlan}'),
                trailing: s.isMember
                    ? TextButton(
                        onPressed: () => ref.read(profileSettingsProvider.notifier).cancelMembership(),
                        child: const Text('取消'),
                      )
                    : null,
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
                    _PlanTile(plan: '月度', price: '￥18/月', desc: '适合短期体验'),
                    _PlanTile(plan: '季度', price: '￥48/季', desc: '更划算'),
                    _PlanTile(plan: '年度', price: '￥168/年', desc: '全年持续疗愈'),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => context.push('/profile/support'),
                      icon: const Icon(Icons.support_agent_rounded),
                      label: const Text('联系客服'),
                    ),
                    const SizedBox(height: 6),
                    Text('提示：文档中会员中心提供“立即开通”入口与客服入口；本 Demo 对应实现。', style: Theme.of(context).textTheme.bodySmall),
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

class _PlanTile extends ConsumerWidget {
  final String plan;
  final String price;
  final String desc;
  const _PlanTile({required this.plan, required this.price, required this.desc});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(profileSettingsProvider);
    final selected = s.memberPlan == plan && s.isMember;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(selected ? Icons.check_circle_rounded : Icons.circle_outlined),
      title: Text('$plan · $price', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
      subtitle: Text(desc),
      onTap: () async {
        int amount;
        if (plan == '月度') {
          amount = 18;
        } else if (plan == '季度') {
          amount = 48;
        } else if (plan == '年度') {
          amount = 168;
        } else {
          amount = 0;
        }
        final result = await showMockPaymentFlow(
          context,
          title: '$plan会员开通',
          amountYuan: amount,
          description: '请选择微信支付或支付宝，输入任意6位密码完成模拟付款。',
        );
        if (result == null || !context.mounted) return;
        ref.read(profileSettingsProvider.notifier).setMembership(plan);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已使用${result.methodLabel}成功开通$plan会员')),
        );
      },
    );
  }
}
