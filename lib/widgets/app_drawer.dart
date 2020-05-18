import 'package:consumify/helpers/custom_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
              title: Text('Consumify Menu'), automaticallyImplyLeading: false),
          Divider(),
          ListTile(
              leading: Icon(Icons.shop),
              title: Text('Shop'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.payment),
              title: Text('Order'),
              onTap: () {
                //Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
                Navigator.of(context).pushReplacement(
                  CustomRoute(
                    builder: (ctxt) => OrdersScreen(),
                  ),
                );
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.edit),
              title: Text('User Products'),
              onTap: () {
                Navigator.of(context).pushNamed(UserProductsScreen.routeName);
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context)
                    .pop(); // We need to close the drawer first to avoid error during logout
                Navigator.of(context).pushReplacementNamed(
                    '/'); // goto homescreen to avoid unexpected behavior
                Provider.of<Auth>(context, listen: false).logout();
              }),
        ],
      ),
    );
  }
}
