import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryData;
  String _userId;

  Future _autheticate(String email, String password, String urlSegment) async {
    var url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$FIREBASE_WEB_API_KEY";
    final response = await http.post(
      url,
      body: json.encode(
        {'email': email, 'password': password, 'returnSecureToken': true},
      ),
    );
    print(json.decode(response.body));
  }

  Future<void> login(String email, String password) async {
    return await _autheticate(email, password, 'signInWithPassword');
  }

  Future<void> signup(String email, String password) async {
    return await _autheticate(email, password, 'signUp');
  }
}
