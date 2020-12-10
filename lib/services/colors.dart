import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class ColorService with ChangeNotifier {
  final _defaultColor = Colors.black;
  final _defaultLightTextColor = Colors.blueGrey[600];
  final _disabledTextColor = Colors.grey[350];
  final _detailTextColor = Colors.white;
  final _defaultBackgroundColor = Colors.white;

  Color getPrimaryColor() => _defaultColor;
  Color getSecondaryColor() => _defaultLightTextColor;
  Color getDisabledColor() => _disabledTextColor;
  Color getLightTextColor() => _detailTextColor;
  Color getBackgroundColor() => _defaultBackgroundColor;

  Map<String, PaletteColor> colorPaletteMap;

  ColorService() {
    colorPaletteMap = {};
  }

  void addPallete(String imageUrl, String uniqueId) async {
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
        NetworkImage(imageUrl),
        size: Size(100, 200));
    colorPaletteMap[uniqueId] = generator.darkMutedColor != null
        ? generator.darkMutedColor
        : PaletteColor(Colors.blue, 2);
  }
}
