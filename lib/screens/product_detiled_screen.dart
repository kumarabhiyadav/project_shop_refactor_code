// This Widget is detailed view of a particular product
import 'package:flutter/material.dart';
import 'package:project_shop/providers/cart.dart';
import 'package:project_shop/providers/products.dart';
import 'package:project_shop/screens/cart_screen.dart';
import 'package:project_shop/screens/send_invitation_page.dart';
import 'package:provider/provider.dart';

class ProductDetailedScreen extends StatefulWidget {
  static const routeName = './product_detailed_screen';

  @override
  _ProductDetailedScreenState createState() => _ProductDetailedScreenState();
}

var invitations;

class _ProductDetailedScreenState extends State<ProductDetailedScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final ispub = Provider.of<Products>(context, listen: false).ispublisher;

    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context).findProductbyId(productId);
    invitations =
        loadedProduct.invitations; //Extract Invitations from loadedProduct
    final cart = Provider.of<Cart>(context, listen: false);
    var _isProductExist = cart.productExist(productId);
    final snackBar = SnackBar(
      content: Text('Product added to cart Sucessfully!'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          cart.removeSingleItem(productId);
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Container(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height:height * 0.45,
                    width: double.infinity,
                    padding: EdgeInsets.all(width *0.020),
                    child: Image.network(
                      loadedProduct.imageUrl,
                      fit: BoxFit.cover,
                    )),
                Padding(
                  padding:  EdgeInsets.only(left:width *0.020),
                  child: Row(
                    children: [
                      Text(
                        '₹ ${loadedProduct.price.toString()}',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(top:width *0.025),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150,
                        child: Card(
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Divider(),
                              Text(
                                loadedProduct.description,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (!ispub)
              Align(
                alignment: Alignment.bottomCenter,
                child: Card(
                  elevation: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _isProductExist
                          ? TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(CartScreen.routeName);
                              },
                              child: Text('GO TO CART',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black)))
                          : TextButton(
                              onPressed: () {
                                cart.addItem(loadedProduct.id,
                                    loadedProduct.price, loadedProduct.title);

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                setState(() {});
                              },
                              child: Text("ADD TO CART",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black)),
                              style:
                                  TextButton.styleFrom(primary: Colors.green),
                            ),
                      TextButton(
                          onPressed: () {
                             cart.addItem(loadedProduct.id,
                                    loadedProduct.price, loadedProduct.title);
                                    Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
                          },
                          child: Text('BUY NOW',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          style: TextButton.styleFrom(
                              primary: Colors.green,
                              backgroundColor: Colors.red))
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: ispub
          ? FloatingActionButton(
              child: Icon(Icons.person_add),
              onPressed: () {
                Navigator.of(context).pushNamed(SendInvitation.routeName,
                    arguments: {
                      'productID': productId,
                      'invitation': invitations
                    });
              },
            )
          : null,
    );
  }
}
