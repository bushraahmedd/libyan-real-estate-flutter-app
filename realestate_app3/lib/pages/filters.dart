import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String _selectedCity = '';
  String _propertyCategory = '';
  String _propertyType = '';
  double _minPrice = 0;
  double _maxPrice = double.infinity;
  bool _negotiable = false;
  bool _furnished = false;
  bool _hasGarden = false;
  bool _hasElevator = false;
  bool _hasPool = false;
  bool _securityCameras = false;
  bool _isFamilyOnly = false;
  int _floorNumber = 0;
  int _numberOfRooms = 0;
  int _numberOfBathrooms = 0;
  int _numberOfKitchens = 0;
  int _numberOfStreets = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تصفية البحث',
          style: GoogleFonts.cairo(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('اختر المدينة', style: GoogleFonts.cairo(fontSize: 16)),
              DropdownButton<String>(
                value: _selectedCity.isNotEmpty ? _selectedCity : null,
                items: <String>[
                  'طرابلس',
                  'بنغازي',
                  'مصراتة',
                  'سبها',
                  'الخمس',
                  'زوارة',
                  "البيضاء",
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: GoogleFonts.cairo()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCity = newValue!;
                  });
                },
                isExpanded: true,
              ),
              SizedBox(height: 10),
              Text('فئة العقار', style: GoogleFonts.cairo(fontSize: 16)),
              DropdownButton<String>(
                value: _propertyCategory.isNotEmpty ? _propertyCategory : null,
                items: [
                  {'label': 'منزل', 'icon': Icons.house},
                  {'label': 'شقة', 'icon': Icons.apartment},
                  {'label': 'أرض', 'icon': Icons.landscape},
                  {'label': 'منزل العطلة', 'icon': Icons.beach_access},
                  {'label': 'محل', 'icon': Icons.store},
                  {'label': 'مكتب', 'icon': Icons.business},
                  {'label': 'مصنع', 'icon': Icons.factory},
                  {'label': 'جناح فندقي', 'icon': Icons.hotel},
                  {'label': 'ملعب كرة قدم', 'icon': Icons.sports_soccer},
                  {'label': 'مكان حفلات الزفاف', 'icon': Icons.event},
                ].map((item) {
                  return DropdownMenuItem<String>(
                    value: item['label'] as String,
                    child: Row(
                      children: [
                        Icon(item['icon'] as IconData, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(item['label'] as String,
                            style: GoogleFonts.cairo()),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _propertyCategory = newValue!;
                  });
                },
                isExpanded: true,
              ),
              SizedBox(height: 10),
              Text('نوع العقار', style: GoogleFonts.cairo(fontSize: 16)),
              DropdownButton<String>(
                value: _propertyType.isNotEmpty ? _propertyType : null,
                items: <String>['بيع', 'إيجار'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: GoogleFonts.cairo()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _propertyType = newValue!;
                  });
                },
                isExpanded: true,
              ),
              SizedBox(height: 10),
              Text('الحد الأدنى للسعر', style: GoogleFonts.cairo(fontSize: 16)),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'أدخل الحد الأدنى للسعر',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _minPrice = double.tryParse(value) ?? 0;
                  });
                },
              ),
              SizedBox(height: 10),
              Text('الحد الأقصى للسعر', style: GoogleFonts.cairo(fontSize: 16)),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'أدخل الحد الأقصى للسعر',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _maxPrice = double.tryParse(value) ?? double.infinity;
                  });
                },
              ),
              SizedBox(height: 10),
              CheckboxListTile(
                title: Text('قابل للتفاوض', style: GoogleFonts.cairo()),
                value: _negotiable,
                onChanged: (bool? value) {
                  setState(() {
                    _negotiable = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: Text('مفروش', style: GoogleFonts.cairo()),
                value: _furnished,
                onChanged: (bool? value) {
                  setState(() {
                    _furnished = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: Text('حديقة', style: GoogleFonts.cairo()),
                value: _hasGarden,
                onChanged: (bool? value) {
                  setState(() {
                    _hasGarden = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              // Add more checkboxes for other fields...

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle filter application
                  Navigator.pop(context, {
                    'city': _selectedCity,
                    'category': _propertyCategory,
                    'type': _propertyType,
                    'minPrice': _minPrice,
                    'maxPrice': _maxPrice,
                    'negotiable': _negotiable,
                    'furnished': _furnished,
                    'hasGarden': _hasGarden,
                    'hasElevator': _hasElevator,
                    'hasPool': _hasPool,
                    'securityCameras': _securityCameras,
                    'isFamilyOnly': _isFamilyOnly,
                    'floorNumber': _floorNumber,
                    'numberOfRooms': _numberOfRooms,
                    'numberOfBathrooms': _numberOfBathrooms,
                    'numberOfKitchens': _numberOfKitchens,
                    'numberOfStreets': _numberOfStreets,
                  });
                },
                child: Text('تطبيق الفلاتر', style: GoogleFonts.cairo()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
