 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realestate_app3/pages/infocard.dart';
 
class SearchResultsPage extends StatelessWidget {
  final List<Map<String, dynamic>> searchResults;

  const SearchResultsPage({Key? key, required this.searchResults})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('نتائج البحث', style: GoogleFonts.cairo()),
      ),
      body: searchResults.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'لا توجد نتائج للبحث',
                    style: GoogleFonts.cairo(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final result = searchResults[index];
                return ListTile(
                  leading: result["photos"] != null
                      ? Image.network(
                          result['photos'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.image, size: 60),
                  title: Text(result['title'] ?? 'No Title',
                      style: GoogleFonts.cairo()),
                  subtitle: Text(result['description'] ?? 'No Description',
                      style: GoogleFonts.cairo()),
                  onTap: () {
                    // Navigate to a detail page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyDetailsPage(
                          property: result,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}