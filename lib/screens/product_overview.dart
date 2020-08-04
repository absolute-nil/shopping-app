import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/products.dart';
import '../widgets/product_item.dart';

class ProductsOverview extends StatelessWidget {
  final List<Product> loadedProducts = productsData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping App"),
      ),
      body: GridView.builder(
          padding: EdgeInsets.all(10),
          itemBuilder: (ctx, i) => ProductItem(
              loadedProducts[i].id,
              loadedProducts[i].title,
              loadedProducts[i].description,
              loadedProducts[i].price,
              loadedProducts[i].imageUrl),
          itemCount: loadedProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10)),
    );
  }
}
