import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:project_shop/models/http_exception.dart';
import 'package:project_shop/providers/auth_provider.dart';
import 'package:project_shop/widgets/login-and-register-page-helper.dart';
import 'package:project_shop/widgets/login_widget.dart';
import 'package:project_shop/widgets/sign_up_as_publisher_page_widget.dart';
import 'package:provider/provider.dart';

class SignUpAsSalesManWidget extends StatefulWidget {
  static const routeName = './sign_up_as_salesman';

  @override
  _SignUpAsSalesManWidgetState createState() => _SignUpAsSalesManWidgetState();
}

class _SignUpAsSalesManWidgetState extends State<SignUpAsSalesManWidget> {
  final _form = GlobalKey<FormState>();
  var _isloading = false;
  Map _initValue = {
    'name': '',
    'email': '',
    'password': '',
    'location': '',
    'sales': '',
    'contact': '',
  };
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
              Navigator.of(context).pushReplacementNamed(LogInWidget.routeName);
            },
          )
        ],
      ),
    );
  }

  Future<void> _onSubmitForm() async {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      setState(() {
        _isloading = true;
      });
      try {

          await Provider.of<AuthProvider>(context, listen: false).createUser(values: _initValue,role: "salesman");

        // await Provider.of<AuthProvider>(context, listen: false)
        //     .signUpAsSalesman(
        //   name: _initValue['name'],
        //   email: _initValue['email'],
        //   password: _initValue['password'],
        //   location: _initValue['loaction'],
        //   contact: _initValue['contact'],
        //   sales: _initValue['sales'],
        // );
        setState(() {
          _isloading = false;
        });
        Navigator.of(context).pushReplacementNamed(LogInWidget.routeName);
      } on HttpException catch (error) {
        var errorMessage = 'Authentication failed';
        if (error.toString().contains('DUBLICATE_VALUE')) {
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
      setState(() {
        _isloading = false;
      });
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
                backgroundColor: Colors.red,
              ))
            : Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AuthPageHeader(
                              width: width, height: height, title: "Sign-Up,"),
                          AuthHeaderSecText(
                              width: width, title: 'As a Salesman')
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: width * 0.025),
                        child: Container(
                          height: height * 0.5,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 10),
                                    color: Colors.black45,
                                    blurRadius: 10)
                              ]),
                          child: ListView(
                            children: [
                              AuthPageSubText(width: width, title: "Name"),
                              userinputfields(
                                  width: width,
                                  hintText: "Enter Your Name",
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return 'Field can not be Empty';
                                    }
                                    return null;
                                  },
                                  onSave: (val) {
                                    _initValue['name'] = val;
                                  },
                                  obscureText: false),
                              AuthPageSubText(width: width, title: "Email"),
                              userinputfields(
                                  width: width,
                                  hintText: 'Enter Your Email-Id / Username',
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
                                    _initValue['email'] = val;
                                  },
                                  obscureText: false),
                              AuthPageSubText(width: width, title: "Password"),
                              userinputfields(
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
                                    _initValue['password'] = val;
                                  },
                                  obscureText: true),
                              AuthPageSubText(width: width, title: "Location"),
                              userinputfields(
                                width: width,
                                hintText: 'Enter Your Location',
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return 'Field can not be Empty';
                                  }
                                  return null;
                                },
                                onSave: (val) {
                                  _initValue['location'] = val;
                                },
                                obscureText: false,
                              ),
                              AuthPageSubText(width: width, title: "Sales"),
                              userinputfields(
                                width: width,
                                hintText: "Enter Numbers of Product You sold",
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return 'Field can not be Empty';
                                  }
                                  return null;
                                },
                                onSave: (val) {
                                  _initValue['sales'] = val;
                                },
                                obscureText: false,
                              ),
                              AuthPageSubText(
                                  width: width, title: "Contact No."),
                              userinputfields(
                                width: width,
                                hintText: "Enter Your Contact Number",
                                obscureText: false,
                                onSave: (val) {
                                  _initValue['contact'] = val;
                                },
                                validator: (val) {
                                  if (val.length <= 9) {
                                    return 'Please Enter Valid Contact Number';
                                  }
                                  return null;
                                },
                              )
                            ],
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
                                        SignUpAsPublisherWidget.routeName);
                                  },
                                  child: Text('As Publisher',
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

  Padding userinputfields(
      {double width,
      String hintText,
      Function validator,
      Function onSave,
      bool obscureText}) {
    return Padding(
      padding: EdgeInsets.all(width * 0.025),
      child: TextFormField(
          decoration: InputDecoration(hintText: hintText),
          textInputAction: TextInputAction.next,
          validator: validator,
          obscureText: obscureText,
          onSaved: onSave),
    );
  }
}
