import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Text(
                    'Title',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 10),
                  Consumer<Cart>(
                    builder: (_, cartData, __) => Chip(
                      label: Text('\$${cartData.totalAmount}'),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
