// This is Wideget is return ListTile with product name and accepted status
//NOTE: This page is only visible to user who authenticate as salesman
import 'package:flutter/material.dart';
import 'package:project_shop/providers/products.dart';
import 'package:project_shop/screens/product_detiled_screen.dart';
import 'package:provider/provider.dart';

class InvitationListTile extends StatefulWidget {
  final productId;
  final acceptedStatus;
  final productName;
  final salemanUID;
  InvitationListTile(
      {this.acceptedStatus, this.productId, this.productName, this.salemanUID});

  @override
  _InvitationListTileState createState() => _InvitationListTileState();
}

 

 


class _InvitationListTileState extends State<InvitationListTile> {
  var acceptedStatus;
  @override
  void initState() {
    acceptedStatus=widget.acceptedStatus;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(ProductDetailedScreen.routeName,
            arguments: widget.productId);
      },
      child: Padding(
        padding: EdgeInsets.all(width *0.020),
        child: ListTile(
          title: Text(widget.productName),
          leading: CircleAvatar(
            child: Text(widget.productName[0].toString().toUpperCase()),
          ),
          trailing: acceptedStatus
              ?
               TextButton(
                  child: Text('Accepted'),
                  onPressed: null,
                )
              : TextButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Accept'),
                  onPressed: () {
                    Provider.of<Products>(context, listen: false)
                        .acceptInvitationsBySalesMan(
                            acceptedStatus: widget.acceptedStatus,
                            productId: widget.productId,
                            salesmanUID: widget.salemanUID);
                      setState(() {
                           acceptedStatus=true;
                      });
                  },
                ),
        ),
      ),
    );
  }
}
