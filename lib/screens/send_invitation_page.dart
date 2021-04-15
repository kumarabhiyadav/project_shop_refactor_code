/* This widget is used for publisher 
to show salesmans list nand send invitations
over product */
//NOTE: This page is only visible to user who authenticate as publisher
import 'package:flutter/material.dart';
import 'package:project_shop/providers/products.dart';
import 'package:project_shop/widgets/salesman_list.dart';
import 'package:provider/provider.dart';

class SendInvitation extends StatefulWidget {
  static const routeName = './send_invitation_screen';

  @override
  _SendInvitationState createState() => _SendInvitationState();
}

class _SendInvitationState extends State<SendInvitation> {
  bool _isLoading = true;
  List<SalesMans> salesmans;

  @override
  void initState() {
    fetchSalesman();

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

  fetchSalesman() async {
    try {
      salesmans =
          await Provider.of<Products>(context, listen: false).salesManList();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _showErrorDialog(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map;
    String productId = args['productID'];
    var invitations = args['invitation'];

    return Scaffold(
        appBar: AppBar(
          title: Text('Available Salesmans'),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ))
            : ListView.builder(
                itemBuilder: (ctx, index) => SalesManList(
                  salesmanlist: salesmans,
                  invitation: invitations == null ? [] : List.from(invitations),
                  name: salesmans[index].name,
                  salesmanuid: salesmans[index].uid,
                  productId: productId,
                ),
                itemCount: salesmans.length,
              ));
  }
}
