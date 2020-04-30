import 'package:flutter/foundation.dart';

import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  void addProduct(Product item) {
    _items.add(item);
    notifyListeners();
  }
}