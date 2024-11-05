import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realestate_app3/pages/favoruite.dart';
import 'package:realestate_app3/pages/home.dart';
import 'package:realestate_app3/pages/login.dart';
import 'package:realestate_app3/pages/propertyform.dart';
import 'package:realestate_app3/pages/dashbored.dart';
import 'package:realestate_app3/theme/color.dart';
import 'package:realestate_app3/widgets/bottombar_item.dart';
import 'package:realestate_app3/widgets/popup.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int _activeTab = 0;
  final List _barItems = [
    {
      "icon": Icons.home_outlined,
      "active_icon": Icons.home_rounded,
      "page": const HomePage(),
    },
    {
      "icon": Icons.favorite_border,
      "active_icon": Icons.favorite_outlined,
      "page": SavedPropertiesPage(),
    },
    {
      "icon": Icons.explore,
      "active_icon": Icons.explore,
      "page": SimulationPage (),
    },
    {
      "icon": Icons.edit_document,
      "active_icon": Icons.edit_document,
      "page": DashboardPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: _buildPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          User? user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PropertyFormPage()),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'لست مسجل دخولك',
                  style: GoogleFonts.cairo(),
                ),
                content: Text(
                  'يرجى تسجيل دخولك لمتابعة تنزيل عقارك',
                  style: GoogleFonts.cairo(),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'إلغاء',
                      style: GoogleFonts.cairo(),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      'تسجيل الدخول',
                      style: GoogleFonts.cairo(),
                    ),
                  ),
                ],
              ),
            );
          }
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 48, 12, 255),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildPage() {
    return IndexedStack(
      index: _activeTab,
      children: List.generate(
        _barItems.length,
        (index) => _barItems[index]["page"],
      ),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      elevation: 10,
      shape: CircularNotchedRectangle(),
      color: AppColor.bottomBarColor,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BottomBarItem(
              _barItems[0]["icon"],
              isActive: _activeTab == 0,
              activeColor: const Color.fromARGB(255, 57, 12, 255),
              onTap: () {
                setState(() {
                  _activeTab = 0;
                });
              },
            ),
            BottomBarItem(
              _barItems[1]["icon"],
              isActive: _activeTab == 1,
              activeColor: const Color.fromARGB(255, 12, 57, 255),
              onTap: () {
                setState(() {
                  _activeTab = 1;
                });
              },
            ),
            SizedBox(width: 50), // Add a spacer for the FAB
            BottomBarItem(
              _barItems[2]["icon"],
              isActive: _activeTab == 2,
              activeColor: const Color.fromARGB(255, 12, 36, 255),
              onTap: () {
                setState(() {
                  _activeTab = 2;
                });
              },
            ),
            BottomBarItem(
              _barItems[3]["icon"],
              isActive: _activeTab == 3,
              activeColor: const Color.fromARGB(255, 48, 12, 255),
              onTap: () {
                setState(() {
                  _activeTab = 3;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
