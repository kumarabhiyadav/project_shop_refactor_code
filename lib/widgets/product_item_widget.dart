// Build grids for home page
import 'package:flutter/material.dart';
import 'package:project_shop/providers/product.dart';
import 'package:project_shop/screens/product_detiled_screen.dart';
import 'package:provider/provider.dart';

class ProductItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
  
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailedScreen.routeName, arguments: product.id);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Image.network(
                    product.imageUrl,
                    height: MediaQuery.of(context).size.height * 0.23,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: Colors.black54,
                    child: Text(
                      product.title,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '₹${product.price}',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Text('Published by Publisher Name'),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
