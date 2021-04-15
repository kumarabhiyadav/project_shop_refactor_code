// This is Wideget is return ListTile with salesman name and invite Button
//NOTE: This page is only visible to user who authenticate as Publisher
import 'package:flutter/material.dart';
import 'package:project_shop/providers/products.dart';
import 'package:provider/provider.dart';

class SalesManList extends StatefulWidget {
  final salesmanlist;
  final invitation;
  final String productId;
  final String salesmanuid;
  final String name;

  SalesManList({
    this.salesmanlist,
    this.invitation,
    this.productId,
    this.salesmanuid,
    this.name,
  });
  @override
  _SalesManListState createState() => _SalesManListState();
}


class _SalesManListState extends State<SalesManList> {
  var _isLoading = false;
  var salemans;
  var invitation;
  bool isInvited = false;
  @override
  void initState() {
    salemans = widget.salesmanlist;
    invitation = widget.invitation;
    isInvited = alreadyInvited(widget.salesmanuid);

    super.initState();
  }

  bool alreadyInvited(String uid) {
    var invited = false;
    invitation.forEach((e) {
      if (e['salemanUID'] == uid) {
        invited = true;
        return invited;
      }
    });
    return invited;
  }
// Error Show nahi ho raha hai
  bool acceptedStatus(String uid) {
    var accepted = false;
    invitation.forEach((e) {
      if (e['salemanUID'] == uid) {
        if (e['acceptedStatus']) {
          accepted = true;
          return accepted;
        }
      }
    });
    return accepted;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(widget.name),
        leading: CircleAvatar(
          child: Text('${widget.name[0].toUpperCase()}'),
        ),
        trailing: isInvited
            ? acceptedStatus(widget.salesmanuid)
                ? TextButton(
                    child: Text('Accepted'),
                    onPressed: null,
                  )
                : TextButton(
                    child: Text('Invited'),
                    onPressed: null,
                  )
            : _isLoading
                ? FittedBox(
                    child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ))
                : TextButton.icon(
                    icon: Icon(Icons.send),
                    label: Text('Invite'),
                    onPressed: () {
                      setState(() {
                        _isLoading = true;

                      });
                      Provider.of<Products>(context, listen: false)
                          .registerInvite(widget.productId, widget.salesmanuid)
                          .then((_) {
                        Provider.of<Products>(context, listen: false)
                            .fetchAndSetProducts();
                        setState(() {
                          _isLoading = false;
                          isInvited=true;
                        });
                      });
                    },
                  ),
      ),
    );
  }
}
