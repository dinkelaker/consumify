import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(title: Text('Consumify Menu'), automaticallyImplyLeading: false),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            }
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Order'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
            }
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('User Products'),
            onTap: () {
              Navigator.of(context).pushNamed(UserProductsScreen.routeName);
            }
          ),
        ],
      ),
    );
  }
}
