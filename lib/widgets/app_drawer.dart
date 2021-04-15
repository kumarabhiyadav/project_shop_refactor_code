import 'package:flutter/material.dart';
import 'package:project_shop/providers/auth_provider.dart';
import 'package:project_shop/providers/products.dart';
import 'package:project_shop/screens/edit_product_screen.dart';
import 'package:project_shop/screens/invitation_page_screen.dart';
import 'package:project_shop/screens/manage_products.dart';
import 'package:project_shop/screens/order_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  Widget listTiles(context, String title, IconData icon, Function function) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: function,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ispub = Provider.of<Products>(context, listen: false).ispublisher;

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('App Drawer'),
            automaticallyImplyLeading: false,
          ),
          if (ispub) Divider(),
          if (ispub)
            listTiles(context, "Manage Products", Icons.edit, () {
              Navigator.of(context).pushNamed(ManageProductScreen.routeName);
            }),
          if (ispub) Divider(),
          if (ispub)
            listTiles(context, "Add Product", Icons.add, () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            }),
          if (ispub) Divider(),
          // if (ispub)
          //   listTiles(context, "Sended Invitations", Icons.notifications, () {
          //     Navigator.of(context).pushNamed(SendInvitation.routeName);
          //   }),
          if (!ispub) Divider(),
          if (!ispub)
            listTiles(context, "Invitations", Icons.notifications, () {
              Navigator.of(context).pushNamed(InvitationScreen.routeName);
            }),
          if (!ispub) Divider(),
          if (!ispub)
            listTiles(context, 'Your Orders', Icons.money_sharp, () {
              Navigator.of(context).pushNamed(OrderScreen.routeName);
            }),
          Divider(),
          listTiles(
            context,
            'Log-Out',
            Icons.logout,
            () {
              Provider.of<AuthProvider>(context,listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
