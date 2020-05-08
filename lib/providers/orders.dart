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
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        var orderItem = OrderItem(
          id: orderId,
          dateTime: DateTime.parse(orderData['dateTime']),
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>).map(
            (item) => CartItem(
              id: item['id'],
              title: item['title'],
              price: item['price'],
              quantity: item['quantity'],
            ),
          ).toList(),
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

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://consumify-app.firebaseio.com/orders.json';
    var now = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': now.toIso8601String(),
          'products': cartProducts
              .map((product) => {
                    'id': product.id,
                    'title': product.title,
                    'quantity': product.quantity,
                    'price': product.price,
                  })
              .toList(),
        }),
      );
      var orderId = json.decode(response.body)['name'];

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
}
