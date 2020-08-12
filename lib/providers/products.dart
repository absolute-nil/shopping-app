import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  void updateProduct(String id, Product product){
    final productIndex = _items.indexWhere((product) => product.id == id);
    if(productIndex >=0){
      _items[productIndex] = product;
    }else{
      print("invalid");
    }

    notifyListeners();
  }

  Future<void> addProduct(Product product) {
    const url = "https://shopping-app-70e63.firebaseio.com/products.json";
    return http.post(url,body: json.encode({
      'title': product.title,
      'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl 
    })).then((response){
    final newProduct = Product(
        id: json.decode(response.body)['title'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl);
    _items.add(newProduct);
    notifyListeners();
    }).catchError((error){
      throw error;
    });

  }

  void deleteProduct(String id){
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
