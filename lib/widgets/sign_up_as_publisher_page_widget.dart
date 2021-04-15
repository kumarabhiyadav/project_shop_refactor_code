import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:project_shop/models/http_exception.dart';
import 'package:project_shop/providers/auth_provider.dart';
import 'package:project_shop/screens/auth_screen.dart';
import 'package:project_shop/widgets/login_widget.dart';
import 'package:project_shop/widgets/sign_up_as_salesman_widget.dart';
import 'package:provider/provider.dart';

class SignUpAsPublisherWidget extends StatefulWidget {
  static const routeName = './sign_up_widget';
  @override
  _SignUpAsPublisherWidgetState createState() =>
      _SignUpAsPublisherWidgetState();
}

class _SignUpAsPublisherWidgetState extends State<SignUpAsPublisherWidget> {
  final _form = GlobalKey<FormState>();
  var _isloading = false;

  String name = '';
  String email = '';
  String password = '';

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
              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            },
          )
        ],
      ),
    );
  }

  Future<void> _onSubmitForm() async {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      try {
        setState(() {
          _isloading = true;
        });
        await Provider.of<AuthProvider>(context, listen: false)
            .signUpAsPublisher(name: name, email: email, password: password);
      } on HttpException catch (error) {
        var errorMessage = 'Authentication failed';
        if (error.toString().contains('EMAIL_EXISTS')) {
          errorMessage = 'This email address is already in use.';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'This is not a valid email address';
        } else if (error.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'This password is too weak.';
        } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Could not find a user with that email.';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'Invalid password.';
        }
        setState(() {
          _isloading = false;
        });
        _showErrorDialog(errorMessage);
      } catch (error) {
        setState(() {
          _isloading = false;
        });
        const errorMessage =
            'Could not authenticate you. Please try again later.';

        _showErrorDialog(errorMessage);
      }
    } else {
      _showErrorDialog("Some Thing Went Wrong Try again later");
    }
  }

  @override
  Widget build(BuildContext context) {
    final height =MediaQuery.of(context).size.height;
    final width =MediaQuery.of(context).size.width;
    return Scaffold(
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.pink,
            ))
          : SafeArea(
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(left: width *0.025, top: height * 0.1),
                            child: Text(
                              'Sign-Up,',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(width *0.025),
                            child: Text(
                              'As a Publisher',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width *0.025),
                        child: Container(
                          height: height * 0.4,
                          width: double.infinity,
                          child: Card(
                            elevation: 5,
                            child: ListView(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(width *0.020),
                                  child: Text(
                                    "Name",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding:  EdgeInsets.all(width *0.025),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            hintText: 'Enter Your Name'),
                                        textInputAction: TextInputAction.next,
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            return 'Field can not be Empty';
                                          }
                                          return null;
                                        },
                                        onSaved: (val) {
                                          name = val;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:  EdgeInsets.all(width *0.020),
                                  child: Text(
                                    "E-Mail",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                Padding(
                                  padding:  EdgeInsets.all(width *0.020),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: 'Enter Your E-Mail'),
                                    textInputAction: TextInputAction.next,
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return 'Field can not be Empty';
                                      }
                                      if (!EmailValidator.validate(val)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      email = val;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:  EdgeInsets.all(width *0.020),
                                  child: Text(
                                    "Password",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(width *0.020),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: 'Enter Your Password'),
                                    textInputAction: TextInputAction.next,
                                    obscureText: true,
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return 'Field can not be Empty';
                                      }
                                      if (val.length <= 6) {
                                        return 'Password Should be 6 Character long';
                                      }

                                      return null;
                                    },
                                    onSaved: (val) {
                                      password = val;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already Member',
                                  style: TextStyle(fontFamily: 'lato')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacementNamed(
                                        LogInWidget.routeName);
                                  },
                                  child: Text('Sign In',
                                      style: TextStyle(fontFamily: 'lato'))),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Sign-Up',
                                  style: TextStyle(fontFamily: 'lato')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacementNamed(
                                        SignUpAsSalesManWidget.routeName);
                                  },
                                  child: Text('As Salesman',
                                      style: TextStyle(fontFamily: 'lato'))),
                            ],
                          )
                        ],
                      ),
                      Center(
                          child: FloatingActionButton.extended(
                              onPressed: () {
                                _onSubmitForm();
                              },
                              label: Text(''),
                              icon: Icon(Icons.login))),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
