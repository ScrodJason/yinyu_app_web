enum ProductCategory { hot, newArrival, device, accessory }

class Product {
  final String id;
  final String name;
  final ProductCategory category;
  final int priceYuan;
  final int sold;
  final double rating;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.priceYuan,
    required this.sold,
    required this.rating,
  });
}

class CartItem {
  final Product product;
  final int qty;

  const CartItem({required this.product, required this.qty});

  CartItem copyWith({int? qty}) => CartItem(product: product, qty: qty ?? this.qty);
}

class Order {
  final String id;
  final DateTime at;
  final List<CartItem> items;
  final int totalYuan;
  final String status; // 已下单/已发货/运输中/派送中/已签收

  const Order({
    required this.id,
    required this.at,
    required this.items,
    required this.totalYuan,
    required this.status,
  });

  Order copyWith({String? status}) => Order(
        id: id,
        at: at,
        items: items,
        totalYuan: totalYuan,
        status: status ?? this.status,
      );
}
