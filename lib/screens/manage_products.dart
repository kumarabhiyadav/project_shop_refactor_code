import 'package:flutter/material.dart';
import 'package:project_shop/providers/products.dart';
import 'package:project_shop/widgets/product_manage_widget.dart';
import 'package:provider/provider.dart';

class ManageProductScreen extends StatefulWidget {
  static const routeName = './manage_product';

  @override
  _ManageProductScreenState createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
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

  Future<void> _onRefresh(context) async {
    try {
      await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    } catch (e) {
      _showErrorDialog(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context).item;
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Your Products'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: ListView.builder(
          itemBuilder: (ctx, index) => Column(
            children: [
              ProductManageScreen(
                productData[index].id,
                productData[index].title,
                productData[index].imageUrl,
              ),
              Divider(
                height: 20,
                thickness: 2,
              ),
            ],
          ),
          itemCount: productData.length,
        ),
      ),
    );
  }
}
