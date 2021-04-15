/* This widget is used for saleman 
to show invitations of product by publisher
over product */
//NOTE: This page is only visible to user who authenticate as salesman
import 'package:flutter/material.dart';
import 'package:project_shop/providers/products.dart';
import 'package:project_shop/widgets/invitations_list_tile.dart';
import 'package:provider/provider.dart';

class InvitationScreen extends StatefulWidget {
  static const routeName = './invitation_screen';

  @override
  _InvitationScreenState createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  var invitations;
  var _isLoading = false;
  var _isInit = true;
  @override
  void initState() {
    final productData = Provider.of<Products>(context, listen: false);
    final products = productData.item;
    fetchInvitaionsByPublisher(products);
    super.initState();
  }
  
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
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        Provider.of<Products>(context, listen: false)
            .fetchAndSetProducts()
            .then((_) {
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

  fetchInvitaionsByPublisher(product) {
    invitations =
        Provider.of<Products>(context, listen: false).fetchInvitations(product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invitation Screen'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.red,
            ))
          : invitations.isEmpty
              ? Center(
                  child: Text(
                  "You,Dont Have Any Invitations Yet",
                  style: Theme.of(context).textTheme.headline4,
                  softWrap: true,
                ))
              : ListView.separated(
                  itemBuilder: (ctx, index) => InvitationListTile(
                    acceptedStatus: invitations[index].acceptedValue,
                    productId: invitations[index].productID,
                    productName: invitations[index].productName,
                    salemanUID: invitations[index].salemanUID,
                  ),
                  separatorBuilder: (ctx, index) => Divider(
                    height: 2,
                    thickness: 2,
                  ),
                  itemCount: invitations.length,
                ),
    );
  }
}
