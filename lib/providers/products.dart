import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

import '../providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  /*[
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];*/

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String productId) {
    return _items.firstWhere((item) => item.id == productId);
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://consumify-app.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      print(response);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, prodData) {
        loadedProducts.add(
          Product(
            id: productId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product item) async {
    const url = 'https://consumify-app.firebaseio.com/products.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': item.title,
          'description': item.description,
          'imageUrl': item.imageUrl,
          'price': item.price,
          'isFavorite': item.isFavorite,
        }),
      );

      final productId = json.decode(response.body)['name'];
      final newProduct = Product(
        id: productId,
        title: item.title,
        description: item.description,
        price: item.price,
        imageUrl: item.imageUrl,
        isFavorite: item.isFavorite,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://consumify-app.firebaseio.com/products/$id.json';
      http.patch(url,
          body: json.encode({
            'title': updatedProduct.title,
            'description': updatedProduct.description,
            'price': updatedProduct.price,
            'imageUrl': updatedProduct.imageUrl,
          }));
      _items[prodIndex] = updatedProduct;
      notifyListeners();
    } else {
      throw new Exception("Illegal state: not reachable.");
    }
  }

  void removeProduct(String id) {
    final url = 'https://consumify-app.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    // backup product before deleting it
    var productBackupForOptimiticUpdate = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        throw new HttpException('Could not delete product on server. Http error code: ${response.statusCode}');
      }
      // clear backup on success
      productBackupForOptimiticUpdate = null;
    }).catchError((error) {
      print(error);
      // rollback deleting the product in error case
      _items.insert(existingProductIndex, productBackupForOptimiticUpdate);
    });
    notifyListeners();
  }
}
