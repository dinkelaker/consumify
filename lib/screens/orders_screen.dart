import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static String routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Consumer<Orders>(
      builder: (_, ordersData, __) => Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        body: ListView.builder(
          itemCount: ordersData.orders.length,
          itemBuilder: (ctxt, index) => OrderItem(ordersData.orders[index]),
        ),
        drawer: AppDrawer(),
      ),
    );
  }
}
