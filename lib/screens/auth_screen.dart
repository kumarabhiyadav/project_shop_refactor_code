import 'package:flutter/material.dart';
import 'package:project_shop/widgets/login_widget.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = './auth_Screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LogInWidget(),
      
    );
  }
}