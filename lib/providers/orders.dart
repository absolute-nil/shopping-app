import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:shopping_app/models/http_expecption.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  static const baseUrl = "https://shopping-app-70e63.firebaseio.com";

  final String authToken;

  List<OrderItem> _orders = [];

  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = "$baseUrl/orders.json?auth=$authToken";
    try {
      final response = await http.get(url);
      final decodedResponse =
          json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      if(decodedResponse == null){
        return;
      }
      decodedResponse.forEach((orderId, orderdata) {
        loadedOrders.insert(
            0,
            OrderItem(
                id: orderId,
                amount: orderdata['amount'],
                dateTime: DateTime.parse(orderdata['dateTime']),
                products: (orderdata['products'] as List<dynamic>)
                    .map((item) => CartItem(
                        id: item['id'],
                        title: item['title'],
                        quantity: item['quantity'],
                        price: item['price']))
                    .toList()));
      });
      _orders = loadedOrders;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    try {
      final time = DateTime.now();
      final response = await http.post("$baseUrl/orders.json?auth=$authToken",
          body: json.encode({
            'amount': total,
            'dateTime': time.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price
                    })
                .toList()
          }));
      if (response.statusCode >= 400) {
        throw HttpException("Could not process order");
      }
      _orders.insert(
          0,
          OrderItem(
              amount: total,
              dateTime: time,
              id: json.decode(response.body)['name'],
              products: cartProducts));
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
