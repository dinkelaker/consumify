import 'dart:convert';

import 'package:consumify/models/http_exception.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return (token != null);
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get user {
    return _userId;
  }

  Future _autheticate(String email, String password, String urlSegment) async {
    var url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$FIREBASE_WEB_API_KEY";
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      throw HttpException(responseData['error']['message']);
    }
    //print(json.decode(response.body));
    _token = responseData['idToken'];
    _userId = responseData['localId'];
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: 20,//int.parse(responseData['expiresIn']),
      ),
    );
    print('${DateTime.now()} : user \'$_userId\' successfully logged in.');
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    return await _autheticate(email, password, 'signInWithPassword');
  }

  Future<void> signup(String email, String password) async {
    return await _autheticate(email, password, 'signUp');
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
  }

}
