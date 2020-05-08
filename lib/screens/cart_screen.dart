import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';

import '../widgets/app_drawer.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isOperationInProgress = false;

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
                    !_isOperationInProgress
                        ? FlatButton(
                            child: Text('ORDER NOW'),
                            textColor: Theme.of(context).primaryColor,
                            onPressed: () async {
                              setState(() {
                                _isOperationInProgress = true;
                              });
                              await Provider.of<Orders>(context).addOrder(
                                  cartData.items.values.toList(),
                                  cartData.totalAmount);
                              cartData.clear();
                              setState(() {
                                _isOperationInProgress = false;
                              });
                            },
                          )
                        : CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctxt, index) => CartItem(
                  cartData.items.values.toList()[index].id,
                  cartData.items.keys
                      .toList()[index], // this is the unique key of the widget
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
      drawer: AppDrawer(),
    );
  }
}
