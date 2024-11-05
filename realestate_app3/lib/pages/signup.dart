import 'dart:convert'; // For Base64 encoding
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker_web/image_picker_web.dart'; // Import this for web
import 'package:google_fonts/google_fonts.dart';

import 'package:realestate_app3/pages/root.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _imageBase64;
  bool _termsChecked = false;

  Future<void> _getImage() async {
    if (kIsWeb) {
      final pickedImage = await ImagePickerWeb.getImageAsBytes();
      if (pickedImage != null) {
        final base64String = base64Encode(pickedImage);
        setState(() {
          _imageBase64 = base64String;
        });
      }
    } else {
      // Code for mobile platform, if needed
    }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate() && _termsChecked) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Save user information to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'photoBase64': _imageBase64 ?? '', // Save Base64 string
        });

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const RootApp(),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'تم تسجيل الحساب بنجاح',
            style: GoogleFonts.cairo(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 0, 42, 231),
          duration: Duration(seconds: 3),
        ));
      } catch (e) {
        print('Error signing up: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            '  حدث خطأ أثناء التسجيل: $e',
            style: GoogleFonts.cairo(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'يرجى قبول الشروط والأحكام',
          style: GoogleFonts.cairo(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 0, 60, 255),
        duration: Duration(seconds: 3),
      ));
    }
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'شروط وأحكام التطبيق',
            style: GoogleFonts.cairo(),
          ),
          content: SingleChildScrollView(
            child: Text(
              'هذا التطبيق سيقوم بإفشاء تفاصيل جهة الاتصال الخاصة بكم، هل توافقون على ذلك؟',
              style: GoogleFonts.cairo(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'موافق',
                style: GoogleFonts.cairo(),
              ),
              onPressed: () {
                setState(() {
                  _termsChecked = true;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'رفض',
                style: GoogleFonts.cairo(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
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
        title: Text(
          'تسجيل حساب جديد',
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _getImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Color.fromARGB(255, 0, 89, 255),
                    backgroundImage: _imageBase64 != null
                        ? MemoryImage(base64Decode(_imageBase64!))
                        : AssetImage('assets/images/default_avatar.png')
                            as ImageProvider,
                    child: _imageBase64 == null
                        ? Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'الاسم',
                  border: OutlineInputBorder(),
                ),
                style: GoogleFonts.cairo(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'يرجى إدخال الاسم';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.cairo(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'يرجى إدخال البريد الإلكتروني';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'صيغة البريد الإلكتروني غير صحيحة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                style: GoogleFonts.cairo(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'يرجى إدخال كلمة المرور';
                  }
                  if (value.length < 8) {
                    return 'يجب أن تكون كلمة المرور على الأقل 8 أحرف';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                style: GoogleFonts.cairo(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'يرجى إدخال رقم الهاتف';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _termsChecked,
                    onChanged: (value) {
                      _showTermsDialog(); // Show terms dialog
                    },
                  ),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        text: 'أوافق على ',
                        style: GoogleFonts.cairo(
                          color: Colors.blue[900],
                        ),
                        children: [
                          TextSpan(
                            text: 'الشروط والأحكام',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _signUp,
                child: Text(
                  'تسجيل',
                  style: GoogleFonts.cairo(),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
