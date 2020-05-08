import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../screens/edit_product_screen.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static final String routeName = '/userProducts';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Products!'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            )
          ],
        ),
        body: Consumer<Products>(
          builder: (_, productsData, __) => RefreshIndicator(
            onRefresh: () => _refreshProducts(context),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (_, index) => Column(
                  children: <Widget>[
                    UserProductItem(
                        productsData.items[index].id,
                        productsData.items[index].title,
                        productsData.items[index].imageUrl),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
        drawer: AppDrawer());
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context).fetchAndSetProducts();
  }
}
