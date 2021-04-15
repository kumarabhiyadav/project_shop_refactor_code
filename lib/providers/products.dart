// This is kind of main file
// many opreations are done here

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:project_shop/models/http_exception.dart';
import 'package:project_shop/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];
  Map<String, String> _salesmanList = {};

  final String authToken;
  final String userId;
  var ispublisher;

  Products(this.authToken, this.userId,
      this.ispublisher); //Receiving authtoken and userId and role of auth user

  Map<String, String> get salesmans {
    return _salesmanList;
  }

  List<Product> get item {
    return [..._items];
  }

  Product findProductbyId(String id) {
    return item.firstWhere((prod) => id == prod.id);
  }

  Future<void> addProduct(Product product) async {
    // Adding new product
    final url =
        'https://shopper-2636c-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'publisherId': userId
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    //update Existing Product
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shopper-2636c-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;

      notifyListeners();
    } else {}
  }

  Future<void> fetchAndSetProducts() async {
    //Fetching product and pass it to product overview page
    // print('this is a $ispublisher');
    final filterString = //filterString used to filter the products if role == publisher
        ispublisher
            ? '&orderBy="publisherId"&equalTo="$userId"'
            : ''; //if role !=publisher then filterString is empty and all products are fetched

    var url =
        'https://shopper-2636c-default-rtdb.firebaseio.com/products.json?auth=$authToken$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            publisherid: prodData['publisherId'],
            invitations: prodData['invitedSalesMan']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> deleteProduct(String id) async {
    //Delete product function
    final url =
        'https://shopper-2636c-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

  salesManList() async {
    // Get All salesman list at time of send invitations to salesmans
    String role;

    try {
      final url =
          'https://shopper-2636c-default-rtdb.firebaseio.com/users.json?auth=$authToken';
      final response = await http.get(url);
      final responseData = json.decode(response.body);
      List<SalesMans> salesman = [];
      responseData.forEach((key, value) {
        role = value['role'];
        if (role == 'Salesman') {
          salesman.add(
            SalesMans(
              name: value['name'],
              uid: value['UID'],
            ),
          );
        }

        notifyListeners();
      });
      return salesman;
    } catch (error) {
      throw error;
    }
  }

  Future<void> registerInvite(
    //Register invitations this funtions is only for publishers
    String prodId,
    String salesmanID,
  ) async {
    List<Map> invite = [];
    try {
      //Fetch all data from product =>invitedSalesman
      final url =
          'https://shopper-2636c-default-rtdb.firebaseio.com/products/$prodId/invitedSalesMan.json?auth=$authToken';
      final response = await http.get(url);
      final responseData = json.decode(response.body);
      if (responseData != null) {
        responseData.forEach((data) {
          invite.add({
            'salemanUID': data['salemanUID'],
            'acceptedStatus': data['acceptedStatus']
          });
        });
      }
    } catch (error) {
      throw error;
    }

    invite.add({'salemanUID': salesmanID, 'acceptedStatus': false});

    try {
      //update data to product =>invitedSalesman
      final url =
          'https://shopper-2636c-default-rtdb.firebaseio.com/products/$prodId.json?auth=$authToken';

      final response =
          await http.patch(url, body: json.encode({'invitedSalesMan': invite}));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (e) {
      throw e;
    }
  }

  fetchInvitations(product) {
    //This fuctions fetch invitations over products and append to List<Invitation> invite;
    List<Invitation> invite = [];
    product.forEach((e) {
      var productid = e.id;
      var productname = e.title;

      if (e.invitations != null) {
        e.invitations.forEach((e) {
          if (e['salemanUID'] == userId) {
            invite.add(Invitation(
                acceptedValue: e['acceptedStatus'],
                salemanUID: e['salemanUID'],
                productID: productid,
                productName: productname));
          }
        });
      }
    });
    return invite;
  }

  void acceptInvitationsBySalesMan(
      // Fuctions workonly if role == salesman it accept the invitations
      {final bool acceptedStatus,
      final productId,
      final salesmanUID}) async {
    List<Map> invite = [];
    //Fetching Data of invitations over
    try {
      final url =
          'https://shopper-2636c-default-rtdb.firebaseio.com/products/$productId/invitedSalesMan.json?auth=$authToken';
      final response = await http.get(url);
      final responseData = json.decode(response.body);
      responseData.forEach((data) {
        invite.add({
          'salemanUID': data['salemanUID'],
          'acceptedStatus': data['acceptedStatus']
        });
      });
      invite.forEach((e) {
        if (e['salemanUID'] == salesmanUID) {
          e['acceptedStatus'] = true;
        }
      });

      try {
        final url =
            'https://shopper-2636c-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken';

        final response = await http.patch(url,
            body: json.encode({'invitedSalesMan': invite}));

        final responseData = json.decode(response.body);
        if (responseData['error'] != null) {
          throw HttpException(responseData['error']['message']);
        }
      } catch (e) {
        throw e;
      }
    } catch (error) {
      throw error;
    }
  }
}

  //Salesman Model
class SalesMans {
  String uid;
  String name;
  SalesMans({this.uid, this.name});
}

  //Invitation Model
class Invitation  {
  String productID;
  String productName;
  String salemanUID;
  bool acceptedValue;
  Invitation(
      {this.salemanUID, this.acceptedValue, this.productID, this.productName});
}

