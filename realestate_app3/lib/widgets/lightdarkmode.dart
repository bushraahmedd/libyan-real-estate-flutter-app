import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realestate_app3/widgets/themeprovider.dart';

class LightDarkModePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Light/Dark Mode'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _toggleTheme(context);
          },
          child: Text('Toggle Theme'),
        ),
      ),
    );
  }

  void _toggleTheme(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.setTheme(
      themeProvider.themeData == ThemeData.light()
          ? ThemeType.dark
          : ThemeType.light,
    );
  }
}
