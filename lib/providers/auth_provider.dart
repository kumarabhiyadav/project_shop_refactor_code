// This file contains actions like login Logout and return property like userid authtoken
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project_shop/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  bool _ispublisher;
  Timer _authTimer;
  bool get isAuth {
    if (token != null) {
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
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _ispublisher=extractedUserData['ispublisher'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  
  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
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
    // prefs.remove('userData');
    prefs.clear();
  }


  Future<bool> authRole() async {
    String role;
    try {
      final url =
          'https://shopper-2636c-default-rtdb.firebaseio.com/users.json?auth=$token&orderBy="UID"&equalTo="$userId"';
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      responseData.forEach((key, value) {
        role = value['role'];
      });

      if (role == "publisher") {
        return true;
      }

      return false;
    } catch (e) {
      throw e;
    }
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
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAU6AU6OSYiqGApqRSbuy9mNi4lB2SLuIw';

      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _ispublisher = await authRole();
      notifyListeners();
       final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
          'ispublisher':_ispublisher,
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  //This Function Sign Up Publisher
  Future<void> signUpAsPublisher({
    String name,
    String email,
    String password,
  }) async {
    DateTime datetime = DateTime.now();
    try {
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAU6AU6OSYiqGApqRSbuy9mNi4lB2SLuIw';

      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
 
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      //If try block does not throw error then this fuction save data of publisher to database
      String userId = responseData['localId'];
      String token = responseData['idToken'];

      await _saveDetailesOfPublisher(userId,token, name, email, datetime); //Saving details of Publisher
    } catch (error) {
      throw error;
    }
  }

// This Function will signUp SalesMan
  Future<void> signUpAsSalesman({
    String name,
    String email,
    String password,
    String location,
    String sales,
    String contact,
  }) async {
    DateTime datetime = DateTime.now();
    try {
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAU6AU6OSYiqGApqRSbuy9mNi4lB2SLuIw';

      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      String userId = responseData['localId'];
      String token = responseData['idToken'];
      await _saveDetailesOfSalesman(
          userid: userId,
          token: token,
          name: name,
          email: email,
          location: location,
          sales: sales,
          contact: contact,
          dateTime: datetime);
    } catch (error) {
      throw error;
    }
  }

// This Function runs  after sign Up as new Publisher and save data according User id return from response
  Future<void> _saveDetailesOfPublisher(
      String userid,String token, String name, String email, DateTime dateTime) async {
    final url = 'https://shopper-2636c-default-rtdb.firebaseio.com/users.json?auth=$token';
    await http.post(
      url,
      body: json.encode({
        'UID': userid,
        'name': name,
        'email': email,
        'role': 'publisher',
        'created_At': dateTime.toIso8601String(),
      }),
    );
  }
}
// This Function runs  after sign Up as new Salesman and save data according User id return from response

Future<void> _saveDetailesOfSalesman(
    {String userid,
    String token,
    String name,
    String email,
    String location,
    String sales,
    String contact,
    DateTime dateTime}) async {
  final url = 'https://shopper-2636c-default-rtdb.firebaseio.com/users.json?auth=$token';
  await http.post(
    url,
    body: json.encode({
      'UID': userid,
      'name': name,
      'email': email,
      'loaction': location,
      'sales': sales,
      'contact': contact,
      'role': 'Salesman',
      'date': dateTime.toIso8601String(),
    }),
  );
  
}

