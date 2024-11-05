import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyDetailsPage extends StatefulWidget {
  final Map<String, dynamic> property;

  PropertyDetailsPage({required this.property});

  @override
  _PropertyDetailsPageState createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  List<String> _imageUrls = [];
  Map<String, Uint8List> _imageDataMap = {};
  bool isSaved = false;
  bool showExtraDetails = false;

  @override
  void initState() {
    super.initState();
    loadImages();
    checkIfSaved();
  }

  void loadImages() async {
    final photos = widget.property['photos'] as List<dynamic>? ?? [];
    for (String photoUrl in photos) {
      final encodedUrl = Uri.encodeFull(photoUrl);
      _imageUrls.add(encodedUrl);
      // Trigger re-render to show CarouselSlider
      setState(() {});
      try {
        final imageData = await _loadImageFromUrl(encodedUrl);
        setState(() {
          _imageDataMap[encodedUrl] = imageData;
        });
      } catch (e) {
        print('Error loading image from URL $encodedUrl: $e');
        setState(() {
          _imageDataMap[encodedUrl] =
              Uint8List.fromList([]); // Placeholder for failed images
        });
      }
    }
  }

  Future<Uint8List> _loadImageFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  void checkIfSaved() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_properties')
          .doc(widget.property['id'])
          .get();
      setState(() {
        isSaved = doc.exists;
      });
    }
  }

  void saveProperty() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_properties')
          .doc(widget.property['id'])
          .set(widget.property);
      setState(() {
        isSaved = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('يرجى تسجيل الدخول لحفظ العقار'),
      ));
    }
  }

  void unsaveProperty() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_properties')
          .doc(widget.property['id'])
          .delete();
      setState(() {
        isSaved = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.property;
    final List<Map<String, String>> details = [
      {'emoji': '📍', 'text': data['location'] ?? ''},
      {'emoji': '🏡', 'text': 'النوع: ${data['type'] ?? ''}'},
      {'emoji': '📂', 'text': 'التصنيف: ${data['propertyCategory'] ?? ''}'},
      {
        'emoji': '💵',
        'text':
            'السعر: ${data['price'] != null && data['price'] != 0 ? data['price'].toString() : ''}'
      },
      {'emoji': '🏠', 'text': 'نوع الإيجار: ${data['rentType'] ?? ''}'},
      if (data['negotiable'] == true) {'emoji': '🤝', 'text': 'قابل للتفاوض'},
    ];

    final List<Map<String, String>> extraDetails = [
      {
        'emoji': '📞',
        'text':
            'الهاتف: ${data['contact']?['phone'] ?? ''}, البريد الإلكتروني: ${data['contact']?['email'] ?? ''}'
      },
      {
        'emoji': '📊',
        'text':
            'عدد الطوابق: ${data['floors'] != null && data['floors'] != 0 ? data['floors'].toString() : ''}'
      },
      {
        'emoji': '🛏️',
        'text':
            'عدد الغرف: ${data['rooms'] != null && data['rooms'] != 0 ? data['rooms'].toString() : ''}'
      },
      {
        'emoji': '🚿',
        'text':
            'عدد الحمامات: ${data['bathrooms'] != null && data['bathrooms'] != 0 ? data['bathrooms'].toString() : ''}'
      },
      {
        'emoji': '🍽️',
        'text':
            'عدد المطابخ: ${data['kitchen'] != null && data['kitchen'] != 0 ? data['kitchen'].toString() : ''}'
      },
      {
        'emoji': '🚦',
        'text': data['streets'] != null && data['streets'] != 0
            ? 'عدد الشوارع: ${data['streets']}'
            : ''
      },
      {
        'emoji': '📏',
        'text':
            'المساحة: ${data['space'] != null && data['space'] != 0 ? data['space'].toString() : ''} متر مربع'
      },
      {
        'emoji': '🪑',
        'text':
            data['isFurnished'] != null && data['isFurnished'] ? 'مفروش' : ''
      },
      {
        'emoji': '🌳',
        'text': data['hasGarden'] != null && data['hasGarden'] ? 'حديقة' : ''
      },
      {
        'emoji': '🏢',
        'text': data['hasElevator'] != null && data['hasElevator'] ? 'مصعد' : ''
      },
      {
        'emoji': '🔌',
        'text': data['hasGenerator'] != null && data['hasGenerator']
            ? 'مولد كهرباء'
            : ''
      },
      {
        'emoji': '📷',
        'text': data['hasSecurityCameras'] != null && data['hasSecurityCameras']
            ? 'كاميرات مراقبة'
            : ''
      },
      {
        'emoji': '🤝',
        'text': data['isNegotiable'] != null && data['isNegotiable']
            ? 'قابل للتفاوض'
            : 'غير قابل للتفاوض'
      },
      {
        'emoji': '👨‍👩‍👧‍👦',
        'text': data['isFamilyOnly'] != null && data['isFamilyOnly']
            ? 'فقط للعائلات'
            : ''
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(data['title'] ?? 'بدون عنوان', style: GoogleFonts.cairo()),
        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () {
              if (isSaved) {
                unsaveProperty();
              } else {
                saveProperty();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                enableInfiniteScroll: false,
                autoPlay: true,
                pauseAutoPlayOnTouch: true,
              ),
              items: _imageUrls.map<Widget>((url) {
                final imageData = _imageDataMap[url];
                return Builder(
                  builder: (BuildContext context) {
                    if (imageData != null && imageData.isNotEmpty) {
                      return Image.memory(
                        imageData,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return Center(child: Text('فشل تحميل الصورة'));
                        },
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text(
              data['title'] ?? 'بدون عنوان',
              style: GoogleFonts.cairo(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            for (var detail in details)
              if (detail['text'] != null && detail['text']!.isNotEmpty)
                _buildDetailRow(
                  emoji: detail['emoji']!,
                  text: detail['text']!,
                ),
            if (showExtraDetails)
              ...extraDetails.map((detail) {
                if (detail['text'] != null && detail['text']!.isNotEmpty) {
                  return _buildDetailRow(
                    emoji: detail['emoji']!,
                    text: detail['text']!,
                  );
                } else {
                  return Container();
                }
              }).toList(),
            if (!showExtraDetails)
              TextButton(
                onPressed: () {
                  setState(() {
                    showExtraDetails = true;
                  });
                },
                child: Text(
                  'المزيد',
                  style: GoogleFonts.cairo(color: Colors.blue),
                ),
              ),
            SizedBox(height: 16.0),
            Text(
              data['description'] ?? 'بدون وصف',
              style: GoogleFonts.cairo(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String emoji, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            emoji,
            style: TextStyle(
              fontSize: 20.0,
              color: Color.fromARGB(255, 0, 58, 184),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.cairo(
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
