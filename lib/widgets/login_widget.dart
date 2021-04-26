import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_shop/models/http_exception.dart';
import 'package:project_shop/providers/auth_provider.dart';
import 'package:project_shop/widgets/login-and-register-page-helper.dart';
import 'package:project_shop/widgets/sign_up_as_publisher_page_widget.dart';
import 'package:provider/provider.dart';

class LogInWidget extends StatefulWidget {
  static const routeName = './login_page';

  @override
  _LogInWidgetState createState() => _LogInWidgetState();
}

class _LogInWidgetState extends State<LogInWidget> {
  final _form = GlobalKey<FormState>();

  var _isloading = false;

  String email = '';

  String password = '';

//Error Message Dialog
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

//Form submit
  Future<void> _onSubmitForm() async {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      try {
        setState(() {
          _isloading = true;
        });
        await Provider.of<AuthProvider>(context, listen: false)
            .logInUser(email: email, password: password);
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

        _showErrorDialog(errorMessage);
      } catch (error) {
        const errorMessage =
            'Could not authenticate you. Please try again later.';
        _showErrorDialog(errorMessage);
      } finally {
        setState(() {
          _isloading = false;
        });
      }
    } else {
      _showErrorDialog("Some Thing Went Wrong Try again later");
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: _isloading
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.pink,
              ))
            : Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthPageHeader(
                        width: width,
                        height: height,
                        title: "Sign-In,",
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: width * 0.025),
                        child: Container(
                            height: height * 0.4,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 10),
                                            color: Colors.black45,
                                            blurRadius: 10)
                                      ]),
                                ),
                                SingleChildScrollView(
                                                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AuthPageSubText(
                                          width: width,
                                          title: "E-Mail",
                                        ),
                                        userInputFeilds(
                                          width: width,
                                          hintText:
                                              'Enter Your Email-Id / Username',
                                          validator: (val) {
                                            if (val.isEmpty) {
                                              return 'Field can not be Empty';
                                            }
                                            if (!EmailValidator.validate(val)) {
                                              return 'Please enter a valid email';
                                            }
                                            return null;
                                          },
                                          onSave: (val) {
                                            email = val;
                                          },
                                          obscureText: false
                                        ),
                                        AuthPageSubText(
                                          width: width,
                                          title: "Password",
                                        ),
                                        userInputFeilds(
                                            width: width,
                                            hintText: 'Enter Your Password',
                                            validator: (val) {
                                              if (val.isEmpty) {
                                                return 'Field can not be Empty';
                                              }
                                              if (val.length <= 6) {
                                                return 'Password Should be 6 Character long';
                                              }

                                              return null;
                                            },
                                            onSave: (val) {
                                              password = val;
                                            },
                                            obscureText: true),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: width * 0.020),
                                          child: Text(
                                            'or sign in using social media',
                                            style: TextStyle(fontFamily: 'lato'),
                                          ),
                                        ),
                                        Divider(
                                          height: 1,
                                        ),
                                        Row(
                                          children: [
                                            socialMediaBtn(
                                              width: width,
                                              icon: Icon(
                                                FontAwesomeIcons.facebook,
                                                size: 45,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            socialMediaBtn(
                                              width: width,
                                              icon: Icon(
                                                FontAwesomeIcons.googlePlus,
                                                size: 45,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                ),
                              ],
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('New User',
                              style: TextStyle(fontFamily: 'lato')),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                    SignUpAsPublisherWidget.routeName);
                              },
                              child: Text('Create an Account',
                                  style: TextStyle(fontFamily: 'lato'))),
                        ],
                      ),
                      Center(
                          child: FloatingActionButton.extended(
                              onPressed: () {
                                _onSubmitForm();
                              },
                              tooltip: "Login",
                              label: Text(''),
                              icon: Icon(Icons.login))),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Padding socialMediaBtn({double width, Icon icon, Color color}) {
    return Padding(
      padding: EdgeInsets.all(width * 0.025),
      child: IconButton(
          icon: icon,
          onPressed: () {
            _showErrorDialog('This Feature is under devlopment');
          }),
    );
  }

  Padding userInputFeilds(
      {String hintText,
      double width,
      Function validator,
      Function onSave,
      bool obscureText}) {
    return Padding(
      padding: EdgeInsets.all(width * 0.025),
      child: TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
          ),
          obscureText: obscureText,
          textInputAction: TextInputAction.next,
          validator: validator,
          onSaved: onSave),
    );
  }
}
