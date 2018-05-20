import 'package:flutter/material.dart';

double _screenWidth;
double _screenHeight;

void initScreen(BuildContext context) {
  var screenSize = MediaQuery.of(context).size;
  _screenWidth = screenSize.width;
  _screenHeight = screenSize.height;
}

double get screenWidth => _screenWidth;

double get screenHeight => _screenHeight;
