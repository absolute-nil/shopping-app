import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/data/products.dart';

import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return GridView.builder(
        padding: EdgeInsets.all(10),
        itemBuilder: (ctx, i) => ProductItem(
            products[i].id,
            products[i].title,
            products[i].description,
            products[i].price,
            products[i].imageUrl),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10));
  }
}
