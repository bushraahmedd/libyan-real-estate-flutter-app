import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<void> _deleteProperty(String propertyId) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد الحذف', style: GoogleFonts.cairo()),
        content:
            Text('هل أنت متأكد من حذف هذا العقار؟', style: GoogleFonts.cairo()),
        actions: [
          TextButton(
            child: Text('إلغاء',
                style: GoogleFonts.cairo(
                    color: const Color.fromARGB(255, 0, 0, 0))),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('حذف', style: GoogleFonts.cairo(color: Colors.red)),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('properties')
                  .doc(propertyId)
                  .delete();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _sponsorProperty(String propertyId) async {
    await FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .update({'sponsored': true});
  }

  void _editProperty(String propertyId, Map<String, dynamic> propertyData) {
    print("Edit Property: $propertyId");
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: const Text('يرجى تسجيل الدخول '));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'عقاراتي',
          style: GoogleFonts.cairo(color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('properties')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'لا يوجد عقارات معروضة.',
                style: GoogleFonts.cairo(
                    fontSize: 18.0, color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final propertyDoc = snapshot.data!.docs[index];
                final property = {
                  ...propertyDoc.data() as Map<String, dynamic>,
                  'id': propertyDoc.id,
                };

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: property['photos'] != null &&
                                          (property['photos'] as List)
                                              .isNotEmpty
                                      ? Image.network(
                                          property['photos']
                                              [0], // Assuming first photo
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(Icons.photo, size: 80),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      property['title'] ?? 'No Title',
                                      style: GoogleFonts.cairo(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      property['description'] ??
                                          'No Description',
                                      style: GoogleFonts.cairo(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0)),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'تواصل: ${property['contact']['phone']}, ${property['contact']['email']}',
                            style: GoogleFonts.cairo(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'الموقع: ${property['location'] ?? 'N/A'}',
                            style: GoogleFonts.cairo(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () =>
                                    _editProperty(property['id'], property),
                                child: Text(
                                  'تعديل',
                                  style: GoogleFonts.cairo(fontSize: 12),
                                ),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Color.fromARGB(255, 21, 0, 214)
                                          .withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () =>
                                    _deleteProperty(property['id']),
                                child: Text(
                                  'حذف',
                                  style: GoogleFonts.cairo(fontSize: 12),
                                ),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () =>
                                    _sponsorProperty(property['id']),
                                child: Text(
                                  '🔥',
                                  style: GoogleFonts.cairo(fontSize: 15),
                                ),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      Color.fromARGB(255, 21, 0, 214),
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
