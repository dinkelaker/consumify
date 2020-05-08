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

  Future<void> fetchAndSetOrders() async {
    const url = 'https://consumify-app.firebaseio.com/orders.json';
    try {
      final response = await http.get(url);
      print(response);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      await Future.forEach<MapEntry<String, dynamic>>(extractedData.entries, (MapEntry<String, dynamic> orderEntry) async {
        final orderId = orderEntry.key;
        final products = await _fetchOrderProducts(orderId);
        
        var orderItem = OrderItem(
          id: orderId,
          dateTime: DateTime.parse(orderEntry.value['dateTime']),
          amount: orderEntry.value['amount'],
          products: products,
        );

        loadedOrders.add(
          orderItem,
        );
      });

      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<List<CartItem>> _fetchOrderProducts(String orderId) async {
    var url =
        'https://consumify-app.firebaseio.com/orders/$orderId/products.json';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<CartItem> loadedOrders = [];
    extractedData.forEach((cartItemId, cartItemData) {
      loadedOrders.add(
        CartItem(
          id: cartItemData['productId'],
          title: cartItemData['title'],
          price: cartItemData['price'],
          quantity: cartItemData['quantity'],
        ),
      );
    });

    return loadedOrders;
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

  Future<void> addProductsToOrder(
      String orderId, List<CartItem> cartProducts) async {
    final url =
        'https://consumify-app.firebaseio.com/orders/$orderId/products.json';

    for (var cartItem in cartProducts) {
      await http.post(
        url,
        body: json.encode({
          'productId': cartItem.id,
          'title': cartItem.title,
          'quantity': cartItem.quantity,
          'price': cartItem.price,
        }),
      );
    }
  }
}
