import 'package:flutter/material.dart';

final themeData = ThemeData.light().copyWith(
    textTheme: ThemeData.light().textTheme.copyWith(
        headline4: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.black,
            fontWeight: FontWeight.bold),
        headline6: TextStyle(
            fontFamily: 'PatrickHand ', color: Colors.white, fontSize: 24),
        bodyText2: TextStyle(fontFamily: 'Lobster', color: Colors.white)));
