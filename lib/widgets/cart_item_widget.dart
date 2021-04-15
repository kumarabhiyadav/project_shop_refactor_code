import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatefulWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  );

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  final inputdialogContoller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Dismissible(
      key: ValueKey(widget.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: width *0.050),
        margin: EdgeInsets.symmetric(
          horizontal:width *0.01 ,
          vertical: height * 0.02,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
              'Do you want to remove the item from the cart?',
            ),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(widget.productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal:width *0.01 ,
          vertical: height * 0.02,
        ),
        child: Padding(
          padding: EdgeInsets.all(width *0.020),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(width *0.012),
                child: FittedBox(
                  child: Text('\₹${widget.price}'),
                ),
              ),
            ),
            title: Text(widget.title),
            subtitle: Text('Total: \₹${(widget.price * widget.quantity)}'),
            trailing: Container(
              width: 110,
              child: Row(
                children: [
                  Text(
                    'Qyt:${widget.quantity}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Enter Quantity'),
                            content: TextFormField(
                              decoration: InputDecoration(hintText: 'Input'),
                              controller: inputdialogContoller,
                              validator: (val) {
                                if (int.tryParse(val) >= 0) {
                                  return null;
                                } else {
                                  return "Enter a Correct Number";
                                }
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Provider.of<Cart>(context, listen: false)
                                      .updatequantity(widget.id,
                                          int.parse(inputdialogContoller.text));
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                                child: Text('Enter'),
                              ),
                            ],
                          ),
                          barrierDismissible: true,
                        );
                      },
                      child: Text("Input")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
