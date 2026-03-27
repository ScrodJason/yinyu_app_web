import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/gradient_background.dart';
import '../state/mall_controller.dart';

class ProductDetailPage extends ConsumerWidget {
  final String productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(mallControllerProvider.notifier);
    final p = ctrl.byId(productId);

    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded)),
                Text('商品详情', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const Spacer(),
                IconButton(onPressed: () => context.push('/mall/cart'), icon: const Icon(Icons.shopping_cart_outlined)),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.10),
                border: Border.all(color: Colors.black.withOpacity(0.06)),
              ),
              child: const Center(child: Icon(Icons.image_outlined, size: 52)),
            ),
            const SizedBox(height: 12),
            Text(p.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text('￥${p.priceYuan} · 已售 ${p.sold} · ${p.rating}⭐', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 14),
            AppCard(
              child: const Text(
                '（演示内容）\n\n这里可以展示：商品参数、设备功能、售后政策、用户评价等。\n本 Demo 不接入真实支付与物流。',
                style: TextStyle(height: 1.45),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      ref.read(mallControllerProvider.notifier).addToCart(p.id);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已加入购物车')));
                    },
                    icon: const Icon(Icons.add_shopping_cart_rounded),
                    label: const Text('加入购物车'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.push('/mall/cart'),
                    child: const Text('去结算'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
