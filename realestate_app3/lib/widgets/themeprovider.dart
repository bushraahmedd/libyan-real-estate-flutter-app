import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeType { light, dark }

class ThemeProvider with ChangeNotifier {
  late ThemeData _themeData;
  late ThemeType _themeType;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get themeData => _themeData;

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _themeType = ThemeType.values[prefs.getInt('theme') ?? 0];
    _themeData = _themeType == ThemeType.light ? ThemeData.light() : ThemeData.dark();
    notifyListeners();
  }

  Future<void> setTheme(ThemeType themeType) async {
    _themeType = themeType;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('theme', _themeType.index);
    _themeData = _themeType == ThemeType.light ? ThemeData.light() : ThemeData.dark();
    notifyListeners();
  }
}
