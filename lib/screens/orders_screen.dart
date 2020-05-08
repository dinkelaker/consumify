import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static String routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isDataFetchedFromServer = false;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    // Only fetch data once, since didChangeDependencies is called multiple times
    // whenever widget tree must be rerendered.
    if (!_isDataFetchedFromServer) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Orders>(context).fetchAndSetOrders().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isDataFetchedFromServer = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Orders>(
      builder: (_, ordersData, __) => Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ordersData.orders.length > 0
                ? ListView.builder(
                    itemCount: ordersData.orders.length,
                    itemBuilder: (ctxt, index) =>
                        OrderItem(ordersData.orders[index]),
                  )
                : Center(
                    child: Text('No orders placed yet!'),
                  ),
        drawer: AppDrawer(),
      ),
    );
  }
}
