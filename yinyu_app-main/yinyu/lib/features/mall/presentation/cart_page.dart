import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/mock_payment_flow.dart';
import '../state/mall_controller.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(mallControllerProvider);
    final ctrl = ref.read(mallControllerProvider.notifier);
    final items = ctrl.cartItems();
    final total = ctrl.cartTotal();

    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded)),
                Text('购物车', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const Spacer(),
                TextButton(
                  onPressed: items.isEmpty ? null : () => ctrl.clearCart(),
                  child: const Text('清空'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (items.isEmpty)
              AppCard(child: Text('购物车为空', style: Theme.of(context).textTheme.bodyMedium))
            else
              ...items.map((it) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                          ),
                          child: const Icon(Icons.inventory_2_outlined),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(it.product.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 2),
                              Text('￥${it.product.priceYuan}', style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                        _QtyStepper(
                          qty: it.qty,
                          onChanged: (q) => ctrl.updateQty(it.product.id, q),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            const SizedBox(height: 12),
            AppCard(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Text('合计：', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                    Text('￥$total', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                    const Spacer(),
                    FilledButton(
                      onPressed: items.isEmpty
                          ? null
                          : () async {
                              final result = await showMockPaymentFlow(
                                context,
                                title: '商城订单支付',
                                amountYuan: total,
                                description: '支持微信支付和支付宝，输入任意6位密码即可完成演示支付。',
                              );
                              if (result == null || !context.mounted) return;
                              final order = ctrl.checkout();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('已使用${result.methodLabel}支付成功')),
                              );
                              context.go('/mall/logistics/${order.id}');
                            },
                      child: const Text('去支付'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text('说明：此结算为模拟下单，订单状态可在“订单”里推进。', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  final int qty;
  final ValueChanged<int> onChanged;
  const _QtyStepper({required this.qty, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => onChanged(qty - 1),
          icon: const Icon(Icons.remove_circle_outline_rounded),
        ),
        Text('$qty', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
        IconButton(
          onPressed: () => onChanged(qty + 1),
          icon: const Icon(Icons.add_circle_outline_rounded),
        ),
      ],
    );
  }
}
