import 'package:flutter/material.dart';

import '../data/products.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [...productsData];

  bool _showFavouriteOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  // void showFavouritesOnly(){
  //   _showFavouriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll(){
  //   _showFavouriteOnly = false;
  //   notifyListeners();
  // }

  void addProduct() {
    // _items.add(value);
    notifyListeners();
  }
}
