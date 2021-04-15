import 'package:flutter/material.dart';
import 'package:project_shop/providers/cart.dart' show Cart;
import 'package:project_shop/providers/orders.dart';
import 'package:project_shop/widgets/cart_item_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const routeName = "./cart_screen";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  final snackBar = SnackBar(
    content: Text('Your Order Has been registered'),
  );
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total',
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      Chip(
                        label: Text(
                          '\₹${cart.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, i) => CartItem(
                    cart.items.values.toList()[i].id,
                    cart.items.keys.toList()[i],
                    cart.items.values.toList()[i].price,
                    cart.items.values.toList()[i].quantity,
                    cart.items.values.toList()[i].title,
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(10.0),
              width: double.infinity,
              child: ElevatedButton(
                  child: Text(
                    "ORDER NOW",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 2),
                  ),
                  onPressed: cart.totalAmount <= 0.0
                      ? null
                      : () {
                          try {
                            Provider.of<Orders>(context, listen: false)
                                .addOrder(
                                    cart.items.values.toList(),
                                    double.parse(
                                        cart.totalAmount.toStringAsFixed(2)));
                            Provider.of<Cart>(context, listen: false).clear();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } catch (e) {
                            _showErrorDialog(e);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(239, 224, 193, 1), // background
                    onPrimary: Colors.red,
                    // foreground
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
