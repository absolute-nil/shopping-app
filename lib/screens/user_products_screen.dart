import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_form_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const route_name = "/user-products";

  Future<void> _refreshProducts(context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ProductFormScreen.route_name);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (_, i) => UserProductItem(
              id: products.items[i].id,
              title: products.items[i].title,
              imageUrl: products.items[i].imageUrl,
              key: ValueKey(products.items[i].id),
            ),
            itemCount: products.items.length,
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
