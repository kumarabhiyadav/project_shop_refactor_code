// This file conatins 2 class OrderItem i.e: 
// 1.Model of placed order (OrderItem)  
// 2.fuctions Like placeorder and fetch userorder detatils
// NOTE: model only for user who authenticate as salesman

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:project_shop/api.dart';

import 'cart.dart';

class OrderItem {
  final String id;
  final amount;
  final  datetime;
  final List<CartItem> products;

  OrderItem({
    @required this.id,
    @required this.datetime,
    @required this.amount,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  final String authToken;
  final String userId;
  Orders(this.authToken, this.userId);
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    // final url =
    //     'https://shopper-2636c-default-rtdb.firebaseio.com/orders.json?auth=$authToken&orderBy="UID"&equalTo="$userId"';
    final url= "$domain${endPoint['orders']}?salesmanUID=$userId";
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body);
    if (extractedData == null) {
      return;
    }
    extractedData['orders'].forEach((orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderData['_id'],
          amount: orderData['amount'],
          datetime:orderData['datetime'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    // final url =
    //     'https://shopper-2636c-default-rtdb.firebaseio.com/orders.json?auth=$authToken';
    final url = '$domain${endPoint['orders']}';
    final response = await http.post(
      url,
      body: json.encode({
        'salesmanUID': userId,
        'amount': total,
        'products': cartProducts
            .map((cp) => {
                  'productId': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
        headers: {'Content-Type': 'application/json'},
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['order']['_id'],
        datetime:json.decode(response.body)['order']['datetime'] ,
        amount: total,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
