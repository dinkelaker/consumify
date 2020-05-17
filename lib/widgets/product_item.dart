import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../providers/products.dart';

import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Product product = Provider.of<Product>(context);
    Products products = Provider.of<Products>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: FadeInImage(
            placeholder: AssetImage('assets/images/product-placeholder.png'),
            image: NetworkImage(product.imageUrl),
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          },
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Consumer<Product>(
              builder: (_, product, child) => Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
            ),
            onPressed: () async {
              product.toggleFavoriteStatus();
              await products.updateProductFavoriteStatus(
                  product.id, product.isFavorite);
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: Consumer<Cart>(
            builder: (_, cartData, child) => IconButton(
              icon: child,
              onPressed: () {
                cartData.addItem(product.id, product.price, product.title);
                // Before showing new SnackBar hide old SnackBars.
                Scaffold.of(context).hideCurrentSnackBar();
                // Access nearest scaffold in widget tree outside of this widget to show SnackBar.
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Added "${product.title}" item to cart!'),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cartData.removeSingleItem(product.id);
                        },
                      )),
                );
              },
            ),
            child: Icon(
              Icons.add_shopping_cart,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
