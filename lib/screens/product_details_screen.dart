import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../providers/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = 'productDetails';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final Product product = Provider.of<Products>(context).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Container(),
    );
  }
}
