import 'package:flutter/material.dart';
import 'package:info_colors/home.dart';

void main() {
  runApp(MaterialApp(
    title: 'Info Colors',
    home: Home(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.grey[900],
      brightness: Brightness.light,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
    ),
    themeMode: ThemeMode.dark,
  ));
}
