import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realestate_app3/pages/edit_screen.dart';
import 'package:realestate_app3/pages/login.dart';

import 'package:realestate_app3/widgets/languagepage.dart';
import 'package:realestate_app3/widgets/setting_item.dart';
import 'package:realestate_app3/widgets/setting_switch.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isDarkMode = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevent dismiss by tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الخروج', style: GoogleFonts.cairo()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('هل أنت متأكد أنك تريد تسجيل الخروج؟',
                    style: GoogleFonts.cairo()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('إلغاء', style: GoogleFonts.cairo()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('تأكيد', style: GoogleFonts.cairo()),
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.chevron_back_outline),
        ),
        leadingWidth: 80,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildLoginButton(context); // Show login button
          } else if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic> userData = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "الإعدادات",
                      style: GoogleFonts.cairo(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "حساب",
                      style: GoogleFonts.cairo(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundImage: userData['photoURL'] != null &&
                                    userData['photoURL'].isNotEmpty
                                ? NetworkImage(userData['photoURL'])
                                : AssetImage("assets/images/avatar.png")
                                    as ImageProvider,
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData['name'] ?? 'غير متوفر',
                                style: GoogleFonts.cairo(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                userData['email'] ?? 'غير متوفر',
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Ionicons.chevron_forward_outline),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfilePage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "الإعدادات",
                      style: GoogleFonts.cairo(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SettingItem(
                      title: "اللغة",
                      icon: Ionicons.earth,
                      bgColor: Colors.orange.shade100,
                      iconColor: Colors.orange,
                      value: "العربية",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LanguagePage()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    SettingItem(
                      title: "الإشعارات",
                      icon: Ionicons.notifications,
                      bgColor: Colors.blue.shade100,
                      iconColor: Colors.blue,
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                    SettingSwitch(
                      title: "الوضع الليلي",
                      icon: Ionicons.moon,
                      bgColor: Colors.purple.shade100,
                      iconColor: Colors.purple,
                      value: isDarkMode,
                      onTap: (value) {
                        setState(() {
                          isDarkMode = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Ionicons.log_out_outline,
                          color: Colors.red),
                      label: Text('تسجيل الخروج', style: GoogleFonts.cairo()),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red,
                        backgroundColor: Colors.red.shade100,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () => _showLogoutConfirmationDialog(context),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return _buildLoginButton(context); // Show login button
          }
        },
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Ionicons.log_in_outline, color: Colors.blue),
        label: Text('تسجيل دخول/انشاء حساب', style: GoogleFonts.cairo()),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.blue.shade100,
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
      ),
    );
  }
}
