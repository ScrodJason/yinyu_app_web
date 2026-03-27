import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/gradient_background.dart';
import '../state/mall_controller.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(mallControllerProvider);
    final ctrl = ref.read(mallControllerProvider.notifier);

    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded)),
                Text('订单', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 10),
            if (st.orders.isEmpty)
              AppCard(child: Text('暂无订单', style: Theme.of(context).textTheme.bodyMedium))
            else
              ...st.orders.map((o) {
                final title = o.items.isEmpty ? '订单' : o.items.first.product.name;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    onTap: () => context.push('/mall/logistics/${o.id}'),
                    child: ListTile(
                      leading: const Icon(Icons.local_shipping_outlined),
                      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                      subtitle: Text('${DateFormat('MM-dd HH:mm').format(o.at)} · ￥${o.totalYuan}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(o.status, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
                          TextButton(
                            onPressed: () {
                              ctrl.advanceOrderStatus(o.id);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('订单状态已推进（演示）')));
                            },
                            child: const Text('推进状态'),
                          ),
                        ],
                      ),
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
