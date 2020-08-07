import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/data/products.dart';

import '../providers/products.dart';

import '../widgets/products_grid.dart';

enum FilterOptions { Favourite, All }

class ProductsOverview extends StatefulWidget {
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  var _showOnlyFavourites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping App"),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions selected_value) {
                setState(() {
                  if (selected_value == FilterOptions.Favourite) {
                    _showOnlyFavourites = true;
                  } else {
                    _showOnlyFavourites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text("Favourites"),
                      value: FilterOptions.Favourite,
                    ),
                    PopupMenuItem(
                        child: Text("All Products"), value: FilterOptions.All)
                  ])
        ],
      ),
      body: ProductsGrid(_showOnlyFavourites),
    );
  }
}
