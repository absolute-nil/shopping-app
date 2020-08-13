import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/http_expecption.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = []; //= [...productsData];

  static const baseUrl = "https://shopping-app-70e63.firebaseio.com";

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

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

  Future<void> updateProduct(String id, Product product) async {
    final url = "$baseUrl/products/$id.json?auth=$authToken";

    final productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      try {
        await http.patch(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'price': product.price,
              'imageUrl': product.imageUrl
            }));
      } catch (e) {
        throw e;
      }
      _items[productIndex] = product;
    } else {
      print("invalid");
    }

    notifyListeners();
  }

  Future<void> fetchAndSetProducts(bool filterByUsers) async {
    final filterString = filterByUsers? 'orderBy="creatorId"&equalTo="$userId"' : "";
    var url = '$baseUrl/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final decodedResponse =
          json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if(decodedResponse == null){
        return;
      }
      url = 'https://shopping-app-70e63.firebaseio.com/userFavourites/$userId.json?auth=$authToken';
      final userResponse = await http.get(url);
      final decodedUserResponse = json.decode(userResponse.body);
      decodedResponse.forEach((productId, productdata) {
        loadedProducts.add(Product(
          id: productId,
          title: productdata['title'],
          description: productdata['description'],
          price: productdata['price'],
          imageUrl: productdata['imageUrl'],
          isFavourite: decodedUserResponse == null? false : decodedUserResponse[productId] ?? false
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addProduct(Product product) async {
    final url = "$baseUrl/products.json?auth=$authToken";
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId
          }));

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print("error in add product" + error.toString());
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async{
        final url = "$baseUrl/products/$id.json?auth=$authToken";

    final deletedProductIndex = _items.indexWhere((product) => product.id == id);
    var deletedProduct = _items[deletedProductIndex];
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if(response.statusCode >= 400){
      _items.insert(deletedProductIndex, deletedProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    deletedProduct = null;

  }
}
