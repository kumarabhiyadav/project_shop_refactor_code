
// This widget return gride view for home page
import 'package:flutter/material.dart';
import 'package:project_shop/providers/products.dart';
import 'package:provider/provider.dart';
import 'package:project_shop/widgets/product_item_widget.dart';

class ProductGridWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final productData = Provider.of<Products>(context);
    final products = productData.item;
    if (productData.item.isEmpty)
      return Center(
        child: Container(
          padding: EdgeInsets.only(left: width *0.037),
          child: Text(
            "Hurry,add your first product for sales",
            style: Theme.of(context).textTheme.headline4,
            // softWrap: true,
          ),
        ),
      );
    else
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3 / 2.2,
          crossAxisSpacing: height * 0.007,
          mainAxisSpacing: width *0.025,
        ),
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
            value: products[index], child: ProductItemWidget()),
        itemCount: products.length,
      );
  }
}
