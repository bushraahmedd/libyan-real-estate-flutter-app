import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:device_preview/device_preview.dart';
import 'package:realestate_app3/pages/splashpage.dart';

import 'theme/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDfhAUdancOSXHp4jGFHsdGWzjzMsGZT1A",
      appId: "1:133487521885:android:69eecc9663ef7bc8b85db4",
      messagingSenderId: "133487521885",
      projectId: "realestae-2app",
      storageBucket: "realestae-2app.appspot.com",
    ),
  );
  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Real Estate App',
      theme: ThemeData(
        primaryColor: AppColor.primary,
        fontFamily: 'Cairo', // Set the Cairo font
      ),
      home: SplashScreen(),
      locale: DevicePreview.locale(context), // Add the locale here
      builder: DevicePreview.appBuilder, // Add the builder here
    );
  }
}
