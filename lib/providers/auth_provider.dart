// This file contains actions like login Logout and return property like userid authtoken
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_shop/api.dart';
import 'dart:convert';

import 'package:project_shop/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  bool _ispublisher = false;
  Timer _authTimer;
  bool get isAuth {
    if (_token != null) {
      return true;
    }
    return false;
  }

  bool get ispublisher {
    return _ispublisher;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _ispublisher = extractedUserData['ispublisher'];

    notifyListeners();

    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.clear();
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> logInUser({String email, String password}) async {
    try {
      // final url =
      //     'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAU6AU6OSYiqGApqRSbuy9mNi4lB2SLuIw';
      final url = "$domain" + "${endPoint['login']}";
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      final responseData = json.decode(response.body);
      if (!responseData['success']) {
        throw HttpException(responseData['error']);
      }

      _token = responseData['token'];
      _userId = responseData['user']['_id'];

      if (responseData['user']['role'] == 'publisher') {
        _ispublisher = true;
      }

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'ispublisher': _ispublisher,
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  //This Function Sign Up Publisher
 
  Future<void> createUser ({dynamic values, String role}) async{
    var body;
    if (role == "salesman") {
      body = json.encode({
        'email': values['email'],
        'password': values['password'],
        'name': values['name'],
        'role': role,
        'sales': values['sales'],
        'contact': values['contact'],
        'location': values['location']
      });
    }
    if (role == "publisher") {
      body = json.encode({
        'email': values['email'],
        'password': values['password'],
        'name': values['name'],
        'role': role,
      });
    }
    try {
      final url = "$domain" + "${endPoint['signup']}";
      final response = await http.post(
        url,
        body: body,
        headers: {'Content-Type': 'application/json'},
      );
      final responseData = json.decode(response.body);
        if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }
    } catch (error) {
      throw error;
    }
  }


}
