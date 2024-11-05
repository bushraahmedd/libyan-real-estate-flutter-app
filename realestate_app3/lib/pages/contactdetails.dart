import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:google_fonts/google_fonts.dart';

class ContactDetailsPage extends StatefulWidget {
  final Map<String, dynamic> propertyData;

  ContactDetailsPage({required this.propertyData});

  @override
  _ContactDetailsPageState createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _whatsappController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  List<String> _photoURLs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserContactDetails();
  }

  @override
  void dispose() {
    _whatsappController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserContactDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _phoneController.text = userDoc['contact']['phone'] ?? '';
        _emailController.text = userDoc['contact']['email'] ?? '';
      });
    }
  }

  Future<void> _pickImage() async {
    Uint8List? image = await ImagePickerWeb.getImageAsBytes();
    if (image != null) {
      String base64String = base64Encode(image);
      setState(() {
        _photoURLs.add('data:image/png;base64,$base64String');
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Show error message if the user is not logged in
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
            content: Text(' يجب ان تكون مسجل دخولك لتنزل عقارك.',
                style: GoogleFonts.cairo()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Generate a unique property ID
      final propertyId =
          FirebaseFirestore.instance.collection('properties').doc().id;

      // Add user ID and property ID to property data
      widget.propertyData['photos'] = _photoURLs;
      widget.propertyData['contact'] = {
        'whatsapp': _whatsappController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
      };
      widget.propertyData['userId'] = user.uid;
      widget.propertyData['propertyId'] =
          propertyId; // Add property ID to property data

      await FirebaseFirestore.instance
          .collection('properties')
          .doc(propertyId) // Use the generated property ID
          .set(widget.propertyData);

      setState(() {
        _isLoading = false;
      });

      // Show success message
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title:
              Text(' ', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text(' تم تنزيل عقارك بنجاح.', style: GoogleFonts.cairo()),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text(' نعم',
                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل التواصل', style: GoogleFonts.cairo()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _whatsappController,
                      decoration: InputDecoration(
                        labelText: 'رقم الواتس اب',
                        labelStyle: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى ادخال رقم الواتس اب';
                        }
                        return null;
                      },
                      style: GoogleFonts.cairo(),
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'رقم الهاتف',
                        labelStyle: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى ادخال رقم الهاتف الخاص بك';
                        }
                        return null;
                      },
                      style: GoogleFonts.cairo(),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'البريد الالكتروني',
                        labelStyle: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى ادخال البريد الالكتروني خاص بك';
                        }
                        return null;
                      },
                      style: GoogleFonts.cairo(),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text(' اختار صور لعقارك',
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 20),
                    _photoURLs.isNotEmpty
                        ? Column(
                            children: _photoURLs.map((url) {
                              if (url.startsWith('data:image/')) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Image.memory(
                                    base64Decode(url.split(',')[1]),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Image.network(
                                    url,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey,
                                        child: Icon(Icons.error,
                                            color: Colors.red),
                                      );
                                    },
                                  ),
                                );
                              }
                            }).toList(),
                          )
                        : Container(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(' تنزيل',
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
