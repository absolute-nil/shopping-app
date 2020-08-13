import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/http_expecption.dart';

class Auth with ChangeNotifier {
  String _userId;
  String _authToken;
  DateTime _expiryDate;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _authToken != null) {
      return _authToken;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlPart) async {
    try {
      final url =
          "https://identitytoolkit.googleapis.com/v1/accounts:$urlPart?key=AIzaSyA2a2gSRk-_1Ku41PlsuSxqOMZ3cEMc1DU";
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      final decodedResponse = json.decode(response.body);
      if (decodedResponse['error'] != null) {
        throw HttpException(decodedResponse['error']['message']);
      }
      _userId = decodedResponse['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(decodedResponse['expiresIn'])));
      _authToken = decodedResponse['idToken'];
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
