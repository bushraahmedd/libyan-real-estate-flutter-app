import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realestate_app3/pages/account_screen.dart';

import 'package:realestate_app3/pages/listing.dart';
import 'package:realestate_app3/theme/color.dart';
import 'package:realestate_app3/utils/data.dart';
import 'package:realestate_app3/widgets/banner_slider.dart';
import 'package:realestate_app3/widgets/company_item.dart';

import 'package:realestate_app3/widgets/recommend_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchController;
  bool _showFilterDrawer = false; // To track if the filter drawer is open

  // Define controllers for filter options
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _roomsController = TextEditingController();
  TextEditingController _bathroomsController = TextEditingController();
  TextEditingController _kitchenController = TextEditingController();
  TextEditingController _floorsController = TextEditingController();
  TextEditingController _streetsController = TextEditingController();

  // Define variables to store selected filter options
  late String _propertyType; // Dropdown selected value

  bool _isNegotiable = false;
  bool _isFurnished = false;
  bool _hasGarden = false;
  bool _hasElevator = false;
  bool _hasGenerator = false;
  bool _hasSecurityCameras = false;
  bool _isFamilyOnly = false;

  final List<String> _propertyTypeOptions = [
    "منزل",
    "منزل عطله",
    "مصنع",
    "مكتب",
    "ملعب كورة",
    "قاعه اعراس",
    "شقه",
    "عماره",
    "محل",
    "ارض",
  ];

  @override
  void initState() {
    super.initState();
    _propertyType = _propertyTypeOptions[0];
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _roomsController.dispose();
    _bathroomsController.dispose();
    _kitchenController.dispose();
    _floorsController.dispose();
    _streetsController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String searchText) async {
    if (searchText.isEmpty) {
      return;
    }

    final titleQuery = await FirebaseFirestore.instance
        .collection('properties')
        .where('title', isGreaterThanOrEqualTo: searchText)
        .where('title', isLessThanOrEqualTo: searchText + '\uf8ff')
        .get();

    final categoryQuery = await FirebaseFirestore.instance
        .collection('properties')
        .where('propertyCategory', isGreaterThanOrEqualTo: searchText)
        .where('propertyCategory', isLessThanOrEqualTo: searchText + '\uf8ff')
        .get();

    final locationQuery = await FirebaseFirestore.instance
        .collection('properties')
        .where('location', isGreaterThanOrEqualTo: searchText)
        .where('location', isLessThanOrEqualTo: searchText + '\uf8ff')
        .get();

    final descriptionQuery = await FirebaseFirestore.instance
        .collection('properties')
        .where('description', isGreaterThanOrEqualTo: searchText)
        .where('description', isLessThanOrEqualTo: searchText + '\uf8ff')
        .get();

    final results = [
      ...titleQuery.docs.map((doc) => doc.data() as Map<String, dynamic>),
      ...categoryQuery.docs.map((doc) => doc.data() as Map<String, dynamic>),
      ...locationQuery.docs.map((doc) => doc.data() as Map<String, dynamic>),
      ...descriptionQuery.docs.map((doc) => doc.data() as Map<String, dynamic>),
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(searchResults: results),
      ),
    );
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
    });
  }

  void _openFilterDrawer() {
    setState(() {
      _showFilterDrawer = true;
    });
  }

  void _applyFilters() {
    // Close the filter drawer
    setState(() {
      _showFilterDrawer = false;
    });

    // Build the query based on the selected filters
    CollectionReference propertiesRef =
        FirebaseFirestore.instance.collection('properties');

    Query filteredQuery = propertiesRef;

    if (_titleController.text.isNotEmpty) {
      filteredQuery =
          filteredQuery.where('title', isEqualTo: _titleController.text);
    }
    if (_descriptionController.text.isNotEmpty) {
      filteredQuery = filteredQuery.where('description',
          isEqualTo: _descriptionController.text);
    }
    if (_propertyType.isNotEmpty) {
      filteredQuery =
          filteredQuery.where('propertyType', isEqualTo: _propertyType);
    }
    if (_isNegotiable) {
      filteredQuery = filteredQuery.where('isNegotiable', isEqualTo: true);
    }
    if (_isFurnished) {
      filteredQuery = filteredQuery.where('isFurnished', isEqualTo: true);
    }
    if (_hasGarden) {
      filteredQuery = filteredQuery.where('hasGarden', isEqualTo: true);
    }
    if (_hasElevator) {
      filteredQuery = filteredQuery.where('hasElevator', isEqualTo: true);
    }
    if (_hasGenerator) {
      filteredQuery = filteredQuery.where('hasGenerator', isEqualTo: true);
    }
    if (_hasSecurityCameras) {
      filteredQuery =
          filteredQuery.where('hasSecurityCameras', isEqualTo: true);
    }
    if (_isFamilyOnly) {
      filteredQuery = filteredQuery.where('isFamilyOnly', isEqualTo: true);
    }

    // Execute the query
    filteredQuery.get().then((querySnapshot) {
      List<Map<String, dynamic>> results = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Navigate to search results page with filtered results
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(searchResults: results),
        ),
      );
    }).catchError((error) {
      // Handle errors if any
      print("Error applying filters: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: AppColor.appBgColor,
                pinned: true,
                snap: true,
                floating: true,
                expandedHeight: 5.0,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                      EdgeInsetsDirectional.only(start: 10, bottom: 16),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AccountScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.account_circle,
                          color: Color.fromARGB(255, 21, 0, 214),
                          size: 30,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'ابحث عن عقار...',
                                hintStyle: GoogleFonts.cairo(
                                  textStyle: TextStyle(color: Colors.grey),
                                ),
                                border: InputBorder.none,
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.grey),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: _clearSearch,
                                        color: Colors.grey,
                                      )
                                    : null,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                              ),
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(color: Colors.black87),
                              ),
                              onSubmitted: _performSearch,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _openFilterDrawer,
                        icon: Icon(Icons.filter_alt_outlined),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildBody(),
              ),
            ],
          ),
          if (_showFilterDrawer)
            _buildFilterDrawer(), // Show filter drawer conditionally
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        const BannerSlider(),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ترشيحات",
                style: GoogleFonts.cairo(
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListingPropertyPage(),
                    ),
                  );
                },
                child: Text(
                  "الكل",
                  style: GoogleFonts.cairo(
                    textStyle: TextStyle(fontSize: 14, color: AppColor.darker),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildRecommended(),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "الاقرب لك",
                style: GoogleFonts.cairo(
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListingPropertyPage(),
                    ),
                  );
                },
                child: Text(
                  "الكل",
                  style: GoogleFonts.cairo(
                    textStyle: TextStyle(fontSize: 14, color: AppColor.darker),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildnearest(),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildRecommended() {
    List<Widget> lists = List.generate(
      recommended.length,
      (index) => RecommendItem(
        data: recommended[index],
        onTap: () {},
      ),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }

  Widget _buildnearest() {
    List<Widget> lists = List.generate(
      nearest.length,
      (index) => NearestItem(
        data: nearest[index],
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }

  Widget _buildFilterDrawer() {
    List<String> _cityOptions = [
      'طرابلس',
      'بنغازي',
      'مصراتة',
      'البيضاء',
      'زليتن',
      'الخمس',
      'سبها',
      'سرت',
      'درنة',
      'طبرق',
      // Add more cities as needed
    ];

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: MediaQuery.of(context).size.height * 0.8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, -1), // Offset to move the shadow up
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Text(
            ' ابحث',
            style: GoogleFonts.cairo(
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 10),
          _buildDropdownOption(
            title: 'المدينة',
            value: _cityOptions[0], // Initial selected city
            items: _cityOptions,
            onChanged: (value) {
              // Handle city selection
              // You can use setState to update the selected city
            },
            icon: Icons.location_city,
          ),
          SizedBox(height: 10),
          _buildTextInputOption(
            title: 'وصف ',
            controller: _descriptionController,
            icon: Icons.description,
          ),
          SizedBox(height: 10),
          _buildDropdownOption(
            title: 'نوع العقار',
            value: _propertyType,
            items: _propertyTypeOptions,
            onChanged: (value) {
              setState(() {
                _propertyType = value.toString();
              });
            },
            icon: Icons.home,
          ),
          SizedBox(height: 20),
          Text(
            'عدد الغرف',
            style: GoogleFonts.cairo(
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
          CounterField(controller: _roomsController),
          SizedBox(height: 20),
          Text(
            'عدد الحمامات',
            style: GoogleFonts.cairo(
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
          CounterField(controller: _bathroomsController),
          SizedBox(height: 20),
          Text(
            'عدد المطابخ',
            style: GoogleFonts.cairo(
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
          CounterField(controller: _kitchenController),
          SizedBox(height: 20),
          Text(
            'عدد الطوابق',
            style: GoogleFonts.cairo(
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
          CounterField(controller: _floorsController),
          SizedBox(height: 20),
          Text(
            'عدد الشوارع',
            style: GoogleFonts.cairo(
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 10),
          _buildSwitchOption(
            title: 'قابل للتفاوض',
            value: _isNegotiable,
            onChanged: (value) {
              setState(() {
                _isNegotiable = value;
              });
            },
            icon: Icons.attach_money,
          ),
          SizedBox(height: 10),
          _buildSwitchOption(
            title: 'مفروش',
            value: _isFurnished,
            onChanged: (value) {
              setState(() {
                _isFurnished = value;
              });
            },
            icon: Icons.king_bed,
          ),
          SizedBox(height: 10),
          _buildSwitchOption(
            title: ' يحتوي على حديقه',
            value: _hasGarden,
            onChanged: (value) {
              setState(() {
                _hasGarden = value;
              });
            },
            icon: Icons.eco,
          ),
          SizedBox(height: 10),
          _buildSwitchOption(
            title: ' مصعد',
            value: _hasElevator,
            onChanged: (value) {
              setState(() {
                _hasElevator = value;
              });
            },
            icon: Icons.elevator,
          ),
          SizedBox(height: 10),
          _buildSwitchOption(
            title: 'مولد كهربائي',
            value: _hasGenerator,
            onChanged: (value) {
              setState(() {
                _hasGenerator = value;
              });
            },
            icon: Icons.settings_input_component,
          ),
          SizedBox(height: 10),
          _buildSwitchOption(
            title: ' كاميرات مراقبه',
            value: _hasSecurityCameras,
            onChanged: (value) {
              setState(() {
                _hasSecurityCameras = value;
              });
            },
            icon: Icons.security,
          ),
          SizedBox(height: 10),
          _buildSwitchOption(
            title: 'عائلات فقط',
            value: _isFamilyOnly,
            onChanged: (value) {
              setState(() {
                _isFamilyOnly = value;
              });
            },
            icon: Icons.family_restroom,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _applyFilters,
            child: Text("طبق الفلتره"),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInputOption({
    required String title,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Color.fromARGB(255, 0, 45, 243), // Change color as needed
      ),
      title: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: title,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdownOption({
    required String title,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color.fromARGB(255, 7, 11, 255),
      ),
      title: DropdownButtonFormField<String>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: title,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildSwitchOption({
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color.fromARGB(255, 73, 7, 255), // Change color as needed
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class CounterField extends StatefulWidget {
  final TextEditingController controller;

  const CounterField({Key? key, required this.controller}) : super(key: key);

  @override
  _CounterFieldState createState() => _CounterFieldState();
}

class _CounterFieldState extends State<CounterField> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.text = '0'; // Initialize the controller with '0'
  }

  void _increment() {
    setState(() {
      _counter++;
      widget.controller.text = _counter.toString();
    });
  }

  void _decrement() {
    setState(() {
      if (_counter > 0) {
        _counter--;
        widget.controller.text = _counter.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: _decrement,
          icon: Icon(Icons.remove),
        ),
        Text(
          '$_counter',
          style: GoogleFonts.cairo(),
        ),
        IconButton(
          onPressed: _increment,
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}

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
              child: Text(
                'لا توجد نتائج للبحث',
                style: GoogleFonts.cairo(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final result = searchResults[index];
                final imageUrl = (result['imageUrls'] != null &&
                        result['imageUrls'].isNotEmpty)
                    ? result['imageUrls'][0]
                    : null;

                return ListTile(
                  leading: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.image, size: 60),
                  title: Text(result['title'] ?? 'No Title',
                      style: GoogleFonts.cairo()),
                  subtitle: Text(result['description'] ?? 'No Description',
                      style: GoogleFonts.cairo()),
                );
              },
            ),
    );
  }
}
