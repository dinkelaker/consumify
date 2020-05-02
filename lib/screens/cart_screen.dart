import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Consumer<Cart>(
        builder: (_, cartData, __) => Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Chip(
                      label: Text('\$${cartData.totalAmount}',
                          style: TextStyle(
                            color:
                                Theme.of(context).primaryTextTheme.title.color,
                          )),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    FlatButton(
                      child: Text('ORDER NOW'),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctxt, index) => CartItem(
                    cartData.items.values.toList()[index].id,
                    cartData.items.keys.toList()[index], // this is the unique key of the widget
                    cartData.items.values.toList()[index].title,
                    cartData.items.values.toList()[index].quantity,
                    cartData.items.values.toList()[index].price,
                ),
                itemCount: cartData.items.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
