import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mall_models.dart';

class MallState {
  final String query;
  final List<Product> products;
  final Map<String, int> cart; // productId -> qty
  final List<Order> orders;

  const MallState({required this.query, required this.products, required this.cart, required this.orders});

  factory MallState.initial() => MallState(
        query: '',
        products: const [
          Product(id: 'pd1', name: '音愈 GSR 可穿戴设备（基础版）', category: ProductCategory.device, priceYuan: 399, sold: 820, rating: 4.7),
          Product(id: 'pd2', name: '音愈 GSR 可穿戴设备（Pro）', category: ProductCategory.device, priceYuan: 699, sold: 430, rating: 4.8),
          Product(id: 'pd3', name: '助眠耳塞（舒适型）', category: ProductCategory.accessory, priceYuan: 39, sold: 5200, rating: 4.6),
          Product(id: 'pd4', name: '冥想眼罩（遮光）', category: ProductCategory.accessory, priceYuan: 59, sold: 2100, rating: 4.5),
          Product(id: 'pd5', name: '当季新品：自然音景会员月卡', category: ProductCategory.newArrival, priceYuan: 18, sold: 12000, rating: 4.9),
          Product(id: 'pd6', name: '销售榜单：缓解焦虑专题（永久解锁）', category: ProductCategory.hot, priceYuan: 48, sold: 8800, rating: 4.8),
        ],
        cart: const {},
        orders: const [],
      );

  MallState copyWith({String? query, List<Product>? products, Map<String, int>? cart, List<Order>? orders}) {
    return MallState(
      query: query ?? this.query,
      products: products ?? this.products,
      cart: cart ?? this.cart,
      orders: orders ?? this.orders,
    );
  }
}

class MallController extends StateNotifier<MallState> {
  MallController() : super(MallState.initial());

  void setQuery(String q) => state = state.copyWith(query: q);

  List<Product> filtered() {
    final q = state.query.trim().toLowerCase();
    if (q.isEmpty) return state.products;
    return state.products.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  Product byId(String id) => state.products.firstWhere((p) => p.id == id, orElse: () => state.products.first);

  void addToCart(String productId, {int qty = 1}) {
    final cart = {...state.cart};
    cart[productId] = (cart[productId] ?? 0) + qty;
    state = state.copyWith(cart: cart);
  }

  void updateQty(String productId, int qty) {
    final cart = {...state.cart};
    if (qty <= 0) {
      cart.remove(productId);
    } else {
      cart[productId] = qty;
    }
    state = state.copyWith(cart: cart);
  }

  void clearCart() => state = state.copyWith(cart: {});

  List<CartItem> cartItems() {
    final items = <CartItem>[];
    for (final e in state.cart.entries) {
      final p = byId(e.key);
      items.add(CartItem(product: p, qty: e.value));
    }
    return items;
  }

  int cartTotal() => cartItems().fold(0, (sum, item) => sum + item.product.priceYuan * item.qty);

  Order checkout() {
    final items = cartItems();
    final total = cartTotal();
    final order = Order(
      id: 'o_${DateTime.now().millisecondsSinceEpoch}',
      at: DateTime.now(),
      items: items,
      totalYuan: total,
      status: '已下单',
    );
    state = state.copyWith(orders: [order, ...state.orders], cart: {});
    return order;
  }

  void advanceOrderStatus(String orderId) {
    const flow = ['已下单', '已发货', '运输中', '派送中', '已签收'];
    final updated = state.orders.map((o) {
      if (o.id != orderId) return o;
      final idx = flow.indexOf(o.status);
      final next = idx >= 0 && idx < flow.length - 1 ? flow[idx + 1] : o.status;
      return o.copyWith(status: next);
    }).toList();
    state = state.copyWith(orders: updated);
  }
}

final mallControllerProvider = StateNotifierProvider<MallController, MallState>((ref) => MallController());
