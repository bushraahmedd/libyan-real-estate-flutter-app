import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realestate_app3/pages/infocard.dart';
import 'package:realestate_app3/pages/login.dart';

class SavedPropertiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('العقارات المحفوظة', style: GoogleFonts.cairo()),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'يجب تسجيل الدخول لرؤيه مفضلاتك',
                style: GoogleFonts.cairo(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('تسجيل الدخول', style: GoogleFonts.cairo()),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('العقارات المحفوظة', style: GoogleFonts.cairo()),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('saved_properties')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final savedProperties = snapshot.data!.docs;

          if (savedProperties.isEmpty) {
            return Center(
                child:
                    Text('لا توجد عقارات محفوظة', style: GoogleFonts.cairo()));
          }

          return ListView.builder(
            itemCount: savedProperties.length,
            itemBuilder: (context, index) {
              final property =
                  savedProperties[index].data() as Map<String, dynamic>;
              final docId = savedProperties[index].id;

              return ListTile(
                leading:
                    property['photos'] != null && property['photos'].isNotEmpty
                        ? Image.network(
                            property['photos'][0],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey,
                            child: Icon(Icons.image, color: Colors.white),
                          ),
                title: Text(property['title'] ?? 'بدون عنوان',
                    style: GoogleFonts.cairo()),
                subtitle: Text(property['location'] ?? '',
                    style: GoogleFonts.cairo()),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('saved_properties')
                        .doc(docId)
                        .delete();
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PropertyDetailsPage(property: property),
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
}
