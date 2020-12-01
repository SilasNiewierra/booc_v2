import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:booc/views/home.dart';
import 'package:booc/views/landing.dart';
import 'package:booc/services/colors.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Provider.of<User>(context) != null
        ? Theme(data: _boocTheme(queryData), child: HomePage())
        : Theme(data: _boocTheme(queryData), child: LandingPage());
  }

  ThemeData _boocTheme(MediaQueryData queryData) {
    double height = queryData.size.height;
    return ThemeData(
      primaryColor: ColorService().getPrimaryColor(),
      accentColor: ColorService().getPrimaryColor(),
      buttonColor: ColorService().getPrimaryColor(),
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: height / 15, color: ColorService().getPrimaryColor()),
        headline2: TextStyle(
            fontSize: height / 20, color: ColorService().getPrimaryColor()),
        headline3: TextStyle(
            fontSize: height / 30, color: ColorService().getPrimaryColor()),
        headline4: TextStyle(
            fontSize: height / 35, color: ColorService().getPrimaryColor()),
        headline5: TextStyle(
            fontSize: height / 50, color: ColorService().getPrimaryColor()),
        headline6: TextStyle(
            fontSize: height / 65, color: ColorService().getPrimaryColor()),
        bodyText1: TextStyle(
            fontSize: height / 70, color: ColorService().getPrimaryColor()),
        bodyText2: TextStyle(
            fontSize: height / 80, color: ColorService().getPrimaryColor()),
      ),
    );
  }
}
