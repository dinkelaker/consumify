import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/products.dart';
import './providers/cart.dart';

import './screens/products_overview_screen.dart';
import './screens/product_details_screen.dart';
import './screens/cart_screen.dart';

void main() => runApp(ConsumifyApp());

class ConsumifyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Products()),
        ChangeNotifierProvider(create: (_) => Cart()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailsScreen.routeName: (_) => ProductDetailsScreen(),
          CartScreen.routeName: (_) => CartScreen(),
        },
      ),
    );
  }
}
