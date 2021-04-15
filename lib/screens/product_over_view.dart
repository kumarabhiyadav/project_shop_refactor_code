// Product OverView page show all the products
// But According to condtions
// Like if User Auth as Publisher it show only the product he uploaded
// If he didn't upload any product it show message to add product
// If Auth is salesman then the all products uploaded by all publisher are show
import 'package:flutter/material.dart';
import 'package:project_shop/providers/cart.dart';
import 'package:project_shop/providers/products.dart';
import 'package:project_shop/screens/cart_screen.dart';
import 'package:project_shop/screens/edit_product_screen.dart';
import 'package:project_shop/screens/invitation_page_screen.dart';
import 'package:project_shop/widgets/app_drawer.dart';
import 'package:project_shop/widgets/badge.dart';
import 'package:project_shop/widgets/product_grid_widget.dart';
import 'package:provider/provider.dart';

class ProductOverViewScreen extends StatefulWidget {
  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var invitations;
  var _isInit = true;
  var _isLoading = false;
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

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onRefresh(context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        Provider.of<Products>(context, listen: false)
            .fetchAndSetProducts()
            .then((_) {
          final productData = Provider.of<Products>(context, listen: false);
          final products = productData.item;
          invitations = Provider.of<Products>(context, listen: false)
              .fetchInvitations(products);

          setState(() {
            _isLoading = false;
          });
        });
      } catch (e) {
        _showErrorDialog(e);
        setState(() {
          _isLoading = false;
        });
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ispub = Provider.of<Products>(context, listen: false).ispublisher;
    return Scaffold(
      appBar: AppBar(title: Text('Shopper'), actions: [
        if (!ispub)
          Badge(
            child: IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.of(context).pushNamed(InvitationScreen.routeName);
                }),
                value: invitations==null?"0":invitations.length.toString(),
          ),
        if (!ispub)
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        if (ispub)
          TextButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: Icon(Icons.add),
              label: Text('Add Your Product'))
      ]),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.red,
            ))
          : RefreshIndicator(
              color: Colors.red,
              backgroundColor: Theme.of(context).primaryColor,
              onRefresh: () => _onRefresh(context),
              child: Consumer<Products>(
                builder: (cxt, productData, _) => ProductGridWidget(),
              ),
            ),
    );
  }
}
