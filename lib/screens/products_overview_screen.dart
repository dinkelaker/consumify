import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All
}

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Consumify'),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (FilterOptions value) {
                final products = Provider.of<Products>(context);
                switch (value) {
                  case FilterOptions.Favorites: 
                    products.showFavoritesOnly(); break;
                  default: 
                    products.showAll();
                }
              },
              icon: Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text('All'),
                  value: FilterOptions.All,
                ),
              ],
            )
          ],
        ),
        body: ProductGrid());
  }
}
