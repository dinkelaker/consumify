import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://consumify-app.firebaseio.com/orders.json';
    var now = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': now.toString(),
        }),
      );
      var orderId = json.decode(response.body)['name'];

      await addProductsToOrder(orderId, cartProducts);

      var orderItem = OrderItem(
        id: orderId,
        amount: total,
        dateTime: now,
        products: cartProducts,
      );
      _orders.insert(0, orderItem);
      notifyListeners();
    } catch (error) {
      _orders.removeAt(0);
      notifyListeners();
    }
  }

  Future<void> addProductsToOrder(String orderId, List<CartItem> cartProducts) async {
    final url =
        'https://consumify-app.firebaseio.com/orders/$orderId/products.json';

    for (var cartItem in cartProducts) {
      await http.post(
        url,
        body: json.encode({
          'id': cartItem.id,
          'title': cartItem.title,
          'quantity': cartItem.quantity,
          'price': cartItem.price,
        }),
      );
    }
  }
}
