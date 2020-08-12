import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/http_expecption.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});

  Future<void> toggleFavourite() async {
    var previousValue = isFavourite;
    isFavourite = !previousValue;
    notifyListeners();
    final url = "https://shopping-app-70e63.firebaseio.com/products/$id.json";
    try {
      final response = await http.patch(url, body: json.encode({'isFavourite': !previousValue}));
      if(response.statusCode >= 400){
        throw HttpException('failed to edit favourite status');

      }
      print(response.statusCode);
      previousValue = null;
    } catch (e) {
      print("exception");
      isFavourite = previousValue;
      notifyListeners();
      throw e;
    }
  }
}
