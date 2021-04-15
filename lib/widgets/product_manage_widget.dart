import 'package:flutter/material.dart';
import 'package:project_shop/providers/products.dart';
import 'package:project_shop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class ProductManageScreen extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  ProductManageScreen(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(onPressed: (){
               Navigator.of(context).pushReplacementNamed(EditProductScreen.routeName,arguments: ["Edit Your Product",id]);
            }, icon: Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                     
                   Provider.of<Products>(context,listen: false).deleteProduct(id);
                   
                },
                icon: Icon(Icons.delete_rounded,color: Colors.red,),
              ),
          ],
        ),
      ),
    );
  }
}
