import 'package:flutter/material.dart';

import '../data/products.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [...productsData];

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  void addProduct() {
    // _items.add(value);
    notifyListeners();
  }
}
