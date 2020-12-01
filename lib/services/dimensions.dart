import 'package:flutter/material.dart';
import 'package:booc/services/colors.dart';

class DimensionsService {
  double _deviceHeight = 2340;
  double _deviceWidth = 1080;
  double _defaultHorizontalPadding = 50;

  TextStyle _headline1;
  TextStyle _headline2;
  TextStyle _headline3;
  TextStyle _headline4;
  TextStyle _headline5;
  TextStyle _headline6;
  TextStyle _author;
  TextStyle _body1;
  TextStyle _body2;
  TextStyle _disabled;
  TextStyle _description;

  DimensionsService(double width, double height) {
    _deviceHeight = height;
    _deviceWidth = width;
    _defaultHorizontalPadding = height / 40;
    _headline1 = TextStyle(
        color: ColorService().getPrimaryColor(), fontSize: height / 15);
    _headline2 = TextStyle(
        color: ColorService().getPrimaryColor(), fontSize: height / 20);
    _headline3 = TextStyle(
        color: ColorService().getPrimaryColor(), fontSize: height / 30);
    _headline4 = TextStyle(
        color: ColorService().getPrimaryColor(),
        fontSize: height / 35,
        fontWeight: FontWeight.w500);
    _headline5 = TextStyle(
        color: ColorService().getPrimaryColor(),
        fontSize: height / 50,
        fontWeight: FontWeight.w500);
    _headline6 = TextStyle(
        color: ColorService().getPrimaryColor(),
        fontSize: height / 65,
        fontWeight: FontWeight.w500);
    _author = TextStyle(
      color: ColorService().getPrimaryColor(),
      fontSize: height / 80,
    );
    _body1 = TextStyle(
        color: ColorService().getLightTextColor(), fontSize: height / 70);
    _body2 = TextStyle(
        color: ColorService().getLightTextColor(), fontSize: height / 80);
    _description = TextStyle(
        color: ColorService().getPrimaryColor(), fontSize: height / 70);
    _disabled = TextStyle(
        color: ColorService().getDisabledColor(),
        fontSize: height / 55,
        fontWeight: FontWeight.w500);
  }

  double getDeviceHeight() => _deviceHeight;
  double getDeviceWidth() => _deviceWidth;
  double getDefaultHorizontalPadding() => _defaultHorizontalPadding;
  TextStyle getH1() => _headline1;
  TextStyle getH2() => _headline2;
  TextStyle getH3() => _headline3;
  TextStyle getH4() => _headline4;
  TextStyle getH5() => _headline5;
  TextStyle getH6() => _headline6;
  TextStyle getBody1() => _body1;
  TextStyle getBody2() => _body2;
  TextStyle getDescriptionStyle() => _description;
  TextStyle getDisabledText() => _disabled;
  TextStyle getAuthorStyle() => _author;
}
