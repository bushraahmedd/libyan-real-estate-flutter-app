import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker_web/image_picker_web.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for the text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Variables to store profile image and URL
  String? _photoURL;
  bool _isEditing = false;
  int _propertiesCount = 0;
  String _joiningDate = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fetch and set user data for editing
  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _photoURL = userData['photoURL'];
          _joiningDate = userData['joiningDate'] ?? '';
        });

        // Fetch properties count
        QuerySnapshot propertyDocs = await _firestore
            .collection('properties')
            .where('userId', isEqualTo: user.uid)
            .get();
        setState(() {
          _propertiesCount = propertyDocs.docs.length;
        });
      }
    }
  }

  // Pick image and encode it to base64
  Future<void> _pickAndUploadImage() async {
    final image = await ImagePickerWeb.getImageAsBytes();
    if (image != null) {
      final base64Image = base64Encode(image);
      final imageUrl = 'data:image/png;base64,$base64Image'; // URL with base64 encoding

      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'photoURL': imageUrl,
        });
        setState(() {
          _photoURL = imageUrl;
        });
      }
    }
  }

  // Update user information
  Future<void> _updateUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تحديث المعلومات بنجاح')),
      );
      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "الملف الشخصي",
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickAndUploadImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _photoURL != null
                      ? (_photoURL!.startsWith('data:image')
                          ? MemoryImage(base64Decode(_photoURL!.split(',')[1])) 
                          : NetworkImage(_photoURL!) as ImageProvider)
                      : null,
                  backgroundColor: Colors.grey[300],
                  child: _photoURL == null
                      ? Icon(Icons.camera_alt,
                          size: 50,
                          color: const Color.fromARGB(255, 255, 255, 255))
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "الاسم",
                labelStyle: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // Adjust font size as needed
                ),
              ),
              readOnly: !_isEditing,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 16, // Adjust font size as needed
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'رقم الهاتف',
                labelStyle: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // Adjust font size as needed
                ),
              ),
              readOnly: !_isEditing,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 16, // Adjust font size as needed
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "البريد الالكتـروني",
                labelStyle: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // Adjust font size as needed
                ),
              ),
              readOnly: !_isEditing,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 16, // Adjust font size as needed
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'عدد العقارات: $_propertiesCount',
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'تاريخ الانضمام: $_joiningDate',
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isEditing ? _updateUserInfo : () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 119, 216),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  child: Text(_isEditing ? 'تحديث المعلومات' : 'تعديل'),
                ),
                if (_isEditing) ...[
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                        _loadUserData(); // Reload user data to discard changes
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    child: Text('إلغاء'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
