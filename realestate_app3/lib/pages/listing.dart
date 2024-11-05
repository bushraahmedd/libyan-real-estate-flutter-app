import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:realestate_app3/pages/infocard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class ListingPropertyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'قوائم العقارات',
          style: GoogleFonts.cairo(
            textStyle: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('properties').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final properties = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              final data = property.data() as Map<String, dynamic>;

              final title = data['title'] ?? 'No Title';
              final description = data['description'] ?? 'No Description';
              final imageUrls =
                  (data.containsKey('photos') && data['photos'] is List)
                      ? List<String>.from(data['photos'])
                      : ['https://via.placeholder.com/150'];
              final location = data['location'] ?? 'No Location';
              final propertyType = data['type'] ?? 'No Type';
              final category = data['propertyCategory'] ??
                  'No Category'; // Ensure correct field name
              final contact = data['contact'] ?? {};
              final userId = data['userId'] ?? '';

              int activeIndex = 0;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder:
                    (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  final userName = userData['name'] ?? 'No Name';
                  final userProfilePic = userData['profilePic'] ??
                      'https://via.placeholder.com/100'; // Fallback image URL

                  final isUserLoggedIn =
                      FirebaseAuth.instance.currentUser != null;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PropertyDetailsPage(property: data),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      shadowColor: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                            child: Stack(
                              children: [
                                CarouselSlider.builder(
                                  itemCount: imageUrls.length,
                                  itemBuilder: (context, index, realIndex) {
                                    return Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Image.network(
                                        imageUrls[index],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Center(child: CircularProgressIndicator());
                                          }
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Center(child: Text('Error loading image'));
                                        },
                                      ),
                                    );
                                  },
                                  options: CarouselOptions(
                                    height:
                                        200.0, // Increased height for better visibility
                                    enableInfiniteScroll: true,
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    aspectRatio: 16 / 9,
                                    viewportFraction: 1.0,
                                    onPageChanged: (index, reason) {
                                      activeIndex = index;
                                    },
                                  ),
                                ),
                                Positioned(
                                  bottom: 10.0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: Center(
                                    child: AnimatedSmoothIndicator(
                                      activeIndex: activeIndex,
                                      count: imageUrls.length,
                                      effect: ExpandingDotsEffect(
                                        activeDotColor: Colors.white,
                                        dotColor: Colors.grey,
                                        dotHeight: 8.0,
                                        dotWidth: 8.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(userProfilePic),
                                      radius: 20.0,
                                      backgroundColor: Colors.grey[200], // Fallback background color
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      userName,
                                      style: GoogleFonts.cairo(
                                        textStyle: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Text(
                                      '📍 $location',
                                      style: GoogleFonts.cairo(
                                        textStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Text(
                                      '🏷️ $category', // Updated to use the correct field
                                      style: GoogleFonts.cairo(
                                        textStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                if (isUserLoggedIn) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _launchWhatsApp(
                                            '${contact['whatsapp'] ?? ''}',
                                            ' مرحبا انا مهتم بعقارك: $title',
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(255, 0, 255,
                                                55), // Green background color
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Text(
                                            '📞', // Emoji for WhatsApp
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _launchEmail(contact['email'] ?? '');
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(255, 37, 33,
                                                243), // Blue background color
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Text(
                                            '📧', // Emoji for email
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _launchPhone(contact['phone'] ?? '');
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(255, 243, 33,
                                                33), // Red background color
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Text(
                                            '📞', // Emoji for phone
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    title,
                                    style: GoogleFonts.cairo(
                                      textStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    description,
                                    style: GoogleFonts.cairo(
                                      textStyle: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'نوع العقار: $propertyType',
                                    style: GoogleFonts.cairo(
                                      textStyle: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'تسجيل الدخول لرؤية تفاصيل الاتصال',
                                      style: GoogleFonts.cairo(
                                        textStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _launchWhatsApp(String phoneNumber, String message) async {
    final whatsappUrl = 'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}';
    try {
      await launch(whatsappUrl);
    } catch (e) {
      print('Could not launch $whatsappUrl');
    }
  }

  void _launchEmail(String email) async {
    final emailUrl = 'mailto:$email';
    try {
      await launch(emailUrl);
    } catch (e) {
      print('Could not launch $emailUrl');
    }
  }

  void _launchPhone(String phone) async {
    final phoneUrl = 'tel:$phone';
    try {
      await launch(phoneUrl);
    } catch (e) {
      print('Could not launch $phoneUrl');
    }
  }
}
