import 'package:flutter/material.dart';

class AuthPageHeader extends StatelessWidget {
  const AuthPageHeader({
    Key key,
    @required this.width,
    @required this.height,
    @required this.title,
  }) : super(key: key);

  final double width;
  final double height;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: width * 0.025, top: height * 0.10, bottom: height * 0.04),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }
}
class AuthPageSubText extends StatelessWidget {
  const AuthPageSubText({Key key, @required this.width, @required this.title})
      : super(key: key);

  final double width;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(width * 0.020),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}

class AuthHeaderSecText extends StatelessWidget {
  const AuthHeaderSecText({
    Key key,
    @required this.width,
    @required this.title,
  }) : super(key: key);

  final double width;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(width *0.025),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
