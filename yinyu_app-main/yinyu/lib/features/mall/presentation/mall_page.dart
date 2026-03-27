import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/section_header.dart';
import '../state/mall_controller.dart';
import '../models/mall_models.dart';

class MallPage extends ConsumerStatefulWidget {
  const MallPage({super.key});

  @override
  ConsumerState<MallPage> createState() => _MallPageState();
}

class _MallPageState extends ConsumerState<MallPage> with SingleTickerProviderStateMixin {
  late final TabController _tab;
  final _tabs = const [
    ('销售榜单', ProductCategory.hot),
    ('当季新品', ProductCategory.newArrival),
    ('设备', ProductCategory.device),
    ('周边', ProductCategory.accessory),
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final st = ref.watch(mallControllerProvider);
    final ctrl = ref.read(mallControllerProvider.notifier);

    final cartCount = st.cart.values.fold<int>(0, (p, c) => p + c);

    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Text('商城', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const Spacer(),
                  IconButton(
                    onPressed: () => context.push('/mall/orders'),
                    icon: const Icon(Icons.receipt_long_rounded),
                    tooltip: '订单',
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () => context.push('/mall/cart'),
                        icon: const Icon(Icons.shopping_cart_outlined),
                        tooltip: '购物车',
                      ),
                      if (cartCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text('$cartCount', style: const TextStyle(color: Colors.white, fontSize: 11)),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: '搜索商品…',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
                onChanged: ctrl.setQuery,
              ),
            ),
            TabBar(
              controller: _tab,
              isScrollable: true,
              tabs: _tabs.map((t) => Tab(text: t.$1)).toList(),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: _tabs.map((t) => _ProductList(category: t.$2)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductList extends ConsumerWidget {
  final ProductCategory category;
  const _ProductList({required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(mallControllerProvider);
    final ctrl = ref.read(mallControllerProvider.notifier);
    final list = ctrl.filtered().where((p) => p.category == category).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      children: [
        const SectionHeader(title: '商品推荐'),
        const SizedBox(height: 10),
        if (list.isEmpty)
          AppCard(child: Text('暂无商品', style: Theme.of(context).textTheme.bodyMedium))
        else
          ...list.map((p) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                onTap: () => context.push('/mall/product/${p.id}'),
                child: ListTile(
                  leading: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                    ),
                    child: const Icon(Icons.inventory_2_outlined),
                  ),
                  title: Text(p.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                  subtitle: Text('￥${p.priceYuan} · 已售 ${p.sold} · ${p.rating}⭐'),
                  trailing: IconButton(
                    onPressed: () {
                      ref.read(mallControllerProvider.notifier).addToCart(p.id);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已加入购物车')));
                    },
                    icon: const Icon(Icons.add_shopping_cart_rounded),
                  ),
                ),
              ),
            );
          }),
        const SizedBox(height: 8),
        Text(
          '说明：文档中“商城”包含商品推荐与物流信息；本 Demo 提供商品列表、详情、购物车、订单与物流状态（演示）。',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
