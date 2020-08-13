import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const route_name = "/orders";

  // var _isLoading = false;

  // @override
  // void initState() {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   Future.delayed(Duration.zero).then((_) => Provider.of<Orders>(context, listen: false).fetchAndSetOrders()).then((_){
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    //! provider with futurebuilder will enter infinite loop
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("your orders"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
            builder: (ctx, dataShapshot) {
              if (dataShapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataShapshot.error != null) {
                  return Center(
                    child: Text("Something went wrong"),
                  );
                } else {
                  return Consumer<Orders>(
                    builder: (ctx, orderData, child) => ListView.builder(
                      itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                      itemCount: orderData.orders.length,
                    ),
                  );
                }
              }
            }));
  }
}
