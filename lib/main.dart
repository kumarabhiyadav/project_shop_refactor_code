import 'package:flutter/material.dart';
import 'package:project_shop/providers/auth_provider.dart';
import 'package:project_shop/providers/cart.dart';
import 'package:project_shop/providers/orders.dart';
import 'package:project_shop/providers/products.dart';
import 'package:project_shop/screens/auth_screen.dart';
import 'package:project_shop/screens/cart_screen.dart';
import 'package:project_shop/screens/edit_product_screen.dart';
import 'package:project_shop/screens/invitation_page_screen.dart';
import 'package:project_shop/screens/manage_products.dart';
import 'package:project_shop/screens/order_screen.dart';
import 'package:project_shop/screens/product_detiled_screen.dart';
import 'package:project_shop/screens/product_over_view.dart';
import 'package:project_shop/screens/send_invitation_page.dart';
import 'package:project_shop/widgets/login_widget.dart';
import 'package:project_shop/widgets/sign_up_as_salesman_widget.dart';
import 'package:project_shop/widgets/sign_up_as_publisher_page_widget.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, Products>(
          create: null,
          update: (_, auth, __) =>
              Products(auth.token, auth.userId, auth.ispublisher),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, Orders>(
          create: null,
          update: (_, auth, __) => Orders(auth.token, auth.userId),
        ),
        // ChangeNotifierProvider.value(
        //   value: Orders(),
        // ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shopper',
          theme: ThemeData(
            primaryColor: Color.fromRGBO(239, 224, 193, 1),
            accentColor: Color.fromRGBO(255, 228, 231, 1),
            fontFamily: 'lato',
            scaffoldBackgroundColor: Color.fromRGBO(245, 238, 237, 1),
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  headline4: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.red),
                  headline3: TextStyle(
                    color: Color.fromRGBO(24, 86, 222, 1),
                  ),
                  headline5: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
          ),
          home: auth.isAuth
              ? ProductOverViewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? MaterialApp(
                              home: Scaffold(
                                  body: SafeArea(
                                      child: Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.red,
                                ),
                              ))),
                            )
                          : AuthScreen(),
                ),
          routes: {
            ManageProductScreen.routeName: (ctx) => ManageProductScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            SignUpAsPublisherWidget.routeName: (ctx) =>
                SignUpAsPublisherWidget(),
            LogInWidget.routeName: (ctx) => LogInWidget(),
            SignUpAsSalesManWidget.routeName: (ctx) => SignUpAsSalesManWidget(),
            ProductDetailedScreen.routeName: (ctx) => ProductDetailedScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            InvitationScreen.routeName: (ctx) => InvitationScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            SendInvitation.routeName: (ctx) => SendInvitation(),
          },
        ),
      ),
    );
  }
}
