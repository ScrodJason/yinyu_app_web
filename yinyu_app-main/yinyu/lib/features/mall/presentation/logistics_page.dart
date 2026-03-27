import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/gradient_background.dart';
import '../state/mall_controller.dart';

class LogisticsPage extends ConsumerWidget {
  final String orderId;
  const LogisticsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(mallControllerProvider);
    final ctrl = ref.read(mallControllerProvider.notifier);

    final order = st.orders.where((o) => o.id == orderId).isNotEmpty
        ? st.orders.firstWhere((o) => o.id == orderId)
        : null;

    return Scaffold(
      body: GradientBackground(
        child: order == null
            ? EmptyState(
                title: '未找到订单',
                subtitle: '请先在购物车下单，或前往订单列表查看。',
                action: FilledButton(
                  onPressed: () => context.go('/mall/orders'),
                  child: const Text('去订单列表'),
                ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded)),
                      Text('物流信息', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          ctrl.advanceOrderStatus(orderId);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('物流状态已推进（演示）')));
                        },
                        child: const Text('推进'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  AppCard(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('订单号：$orderId', style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(height: 6),
                          Text('当前状态：${order.status}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                          const SizedBox(height: 8),
                          Text('合计：￥${order.totalYuan}', style: Theme.of(context).textTheme.bodyMedium),
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
                          Text('物流轨迹（演示）', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 10),
                          ..._timeline(order.status, order.at).map((e) => ListTile(
                                dense: true,
                                leading: Icon(e.isLast ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded),
                                title: Text(e.title),
                                subtitle: Text(DateFormat('MM-dd HH:mm').format(e.time)),
                              )),
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
                          Text('服务评价（演示）', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 10),
                          Row(children: List.generate(5, (i) => const Icon(Icons.star_border_rounded))),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('感谢评价（演示）'))),
                            child: const Text('提交评价'),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  List<_LogEvent> _timeline(String status, DateTime start) {
    const flow = ['已下单', '已发货', '运输中', '派送中', '已签收'];
    final idx = flow.indexOf(status);
    final n = idx < 0 ? 1 : idx + 1;
    final list = <_LogEvent>[];
    for (var i = 0; i < n; i++) {
      list.add(_LogEvent(
        title: flow[i],
        time: start.add(Duration(hours: i * 6)),
        isLast: i == n - 1,
      ));
    }
    return list.reversed.toList();
  }
}

class _LogEvent {
  final String title;
  final DateTime time;
  final bool isLast;
  const _LogEvent({required this.title, required this.time, required this.isLast});
}
