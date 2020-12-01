import 'package:flutter/material.dart';

class ColorService {
  final _defaultColor = Colors.black;
  final _defaultLightTextColor = Colors.blueGrey[600];
  final _disabledTextColor = Colors.grey[350];
  final _detailTextColor = Colors.white;
  final _defaultBackgroundColor = Colors.grey[50];

  Color getPrimaryColor() => _defaultColor;
  Color getSecondaryColor() => _defaultLightTextColor;
  Color getDisabledColor() => _disabledTextColor;
  Color getLightTextColor() => _detailTextColor;
  Color getBackgroundColor() => _defaultBackgroundColor;
}
