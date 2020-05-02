import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
    this.id,
    this.title,
    this.quantity,
    this.price,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('$quantity x'),
          )),
    );
  }
}
