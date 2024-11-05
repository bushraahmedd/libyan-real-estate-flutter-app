import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realestate_app3/pages/contactdetails.dart';

class PropertyFormPage extends StatefulWidget {
  @override
  _PropertyFormPageState createState() => _PropertyFormPageState();
}

class _PropertyFormPageState extends State<PropertyFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  final _spaceController = TextEditingController();
  final _floorController = TextEditingController();
  final _roomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _kitchenController = TextEditingController();
  final _streetsController = TextEditingController();

  String _propertyType = 'إيجار'; // Default selection
  String _rentType = 'شهري'; // Default rent type
  String _propertyCategory = 'منزل'; // Default property category
  bool _isNegotiable = false;
  bool _isFurnished = false;
  bool _hasGarden = false;
  bool _hasElevator = false;
  final bool _hasGenerator = false;
  bool _hasSecurityCameras = false;
  bool _hasPool = false;
  final bool _isFamilyOnly = false;
  int _roomsCount = 0;
  int _bathroomsCount = 0;
  int _kitchensCount = 0;
  int _floorsCount = 0;
  int _streetsCount = 0;
  String _selectedCity = 'طرابلس'; // Default city

  final List<String> _cities = [
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
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _spaceController.dispose();
    _floorController.dispose();
    _roomsController.dispose();
    _bathroomsController.dispose();
    _kitchenController.dispose();
    _streetsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContactDetailsPage(
            propertyData: {
              'title': _titleController.text,
              'description': _descriptionController.text,
              'location': _selectedCity,
              'type': _propertyType,
              'propertyCategory': _propertyCategory,
              'price': _priceController.text,
              'minPrice': _minPriceController.text,
              'maxPrice': _maxPriceController.text,
              'rentType': _rentType,
              'isNegotiable': _isNegotiable,
              'isFurnished': _isFurnished,
              'hasGarden': _hasGarden,
              'hasElevator': _hasElevator,
              'hasGenerator': _hasGenerator,
              'hasSecurityCameras': _hasSecurityCameras,
              '  _hasPool': _hasPool,
              'isFamilyOnly': _isFamilyOnly,
              'space': _spaceController.text,
              'floors': _floorController.text,
              'rooms': _roomsCount.toString(),
              'bathrooms': _bathroomsCount.toString(),
              'kitchen': _kitchensCount.toString(),
              'streets': _streetsController.text,
            },
          ),
        ),
      );
    }
  }

  Widget _buildCustomCheckboxListTile({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String emoji,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: value ? Color.fromARGB(255, 139, 182, 223) : null,
      ),
      child: CheckboxListTile(
        title: Row(
          children: [
            Text(
              emoji,
             style: TextStyle(fontSize: 24, color: Colors.blue)),
         
        
            
            SizedBox(width: 8),
            Text(
              title,
              style:
                  GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
        
          ]
        ),
          
    
        value: value,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        activeColor: Colors.blue,
        checkColor: Colors.white,
        side: MaterialStateBorderSide.resolveWith(
          (states) => const BorderSide(
            color: Color.fromARGB(255, 25, 6, 133),
            width: 1,
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
      ),
    );
  }

  Widget _buildCounterField({
    required String label,
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required String emoji,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              emoji,
              style:TextStyle(fontSize: 24, color: Colors.blue)),
          ]
            ),
            SizedBox(width: 8),
            Text(
              label,
              style:
                  GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          
        
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: value > 0 ? onDecrement : null,
            ),
            Text(
              value.toString(),
              style:
                  GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: onIncrement,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPropertySpecificFields() {
    switch (_propertyCategory) {
      case 'منزل':
      case 'منزل العطلة':
        return Column(children: [
          _buildCustomCheckboxListTile(
            title: 'مفروش',
            value: _isFurnished,
            onChanged: (bool? value) {
              setState(() {
                _isFurnished = value!;
              });
            },
            emoji: '🛋️',
          ),
          _buildCustomCheckboxListTile(
            title: 'حديقة',
            value: _hasGarden,
            onChanged: (bool? value) {
              setState(() {
                _hasGarden = value!;
              });
            },
            emoji: '🛋️',
          ),
          _buildCustomCheckboxListTile(
            title: 'مصعد',
            value: _hasElevator,
            onChanged: (bool? value) {
              setState(() {
                _hasElevator = value!;
              });
            },
            emoji: '🛗',
          ),
          _buildCustomCheckboxListTile(
            title: "حوض سباحه",
            value: _hasElevator,
            onChanged: (bool? value) {
              setState(() {
                _hasPool = value!;
              });
            },
            emoji: '🏊‍♂️',
          ),
          _buildCounterField(
            label: 'عدد الغرف',
            value: _roomsCount,
            onIncrement: () {
              setState(() {
                _roomsCount++;
              });
            },
            onDecrement: () {
              setState(() {
                _roomsCount--;
              });
            },
            emoji: '🛏️',
          ),
          _buildCounterField(
            label: "عدد الطوابق",
            value: _floorsCount,
            onIncrement: () {
              setState(() {
                _floorsCount++;
              });
            },
            onDecrement: () {
              setState(() {
                _floorsCount--;
              });
            },
            emoji: '🏢',
          ),
          _buildCounterField(
            label: 'عدد الحمامات',
            value: _bathroomsCount,
            onIncrement: () {
              setState(() {
                _bathroomsCount++;
              });
            },
            onDecrement: () {
              setState(() {
                _bathroomsCount--;
              });
            },
            emoji: '🚽',
          ),
          _buildCounterField(
            label: 'عدد المطابخ',
            value: _kitchensCount,
            onIncrement: () {
              setState(() {
                _kitchensCount++;
              });
            },
            onDecrement: () {
              setState(() {
                _kitchensCount--;
              });
            },
            emoji: '🍽️',
          ),
          _buildCustomCheckboxListTile(
            title: 'كاميرات مراقبة',
            value: _hasSecurityCameras,
            onChanged: (bool? value) {
              setState(() {
                _hasSecurityCameras = value!;
              });
            },
            emoji: '📹',
          ),
          TextFormField(
            controller: _spaceController,
            decoration: InputDecoration(
                labelText: 'المساحة (متر مربع)',
                labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال المساحة بالمتر المربع';
              }
              return null;
            },
          ),
        ]);

      case 'شقة':
        return Column(children: [
          TextFormField(
            controller: _spaceController,
            decoration: InputDecoration(
                labelText: 'المساحة (متر مربع)',
                labelStyle: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                )),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال المساحة بالمتر المربع';
              }
              return null;
            },
          ),
          _buildCounterField(
            label: 'عدد الغرف',
            value: _roomsCount,
            onIncrement: () {
              setState(() {
                _roomsCount++;
              });
            },
            onDecrement: () {
              setState(() {
                _roomsCount--;
              });
            },
            emoji: '🛏️',
          ),
          _buildCounterField(
            label: "رقم الطابق",
            value: _floorsCount,
            onIncrement: () {
              setState(() {
                _floorsCount++;
              });
            },
            onDecrement: () {
              setState(() {
                _floorsCount--;
              });
            },
            emoji: '🏢',
          ),
          _buildCounterField(
            label: 'عدد الحمامات',
            value: _bathroomsCount,
            onIncrement: () {
              setState(() {
                _bathroomsCount++;
              });
            },
            onDecrement: () {
              setState(() {
                _bathroomsCount--;
              });
            },
            emoji: '🚽',
          ),
          _buildCounterField(
            label: 'عدد المطابخ',
            value: _kitchensCount,
            onIncrement: () {
              setState(() {
                _kitchensCount++;
              });
            },
            onDecrement: () {
              setState(() {
                _kitchensCount--;
              });
            },
            emoji: '🍽️',
          ),
        ]);
      case 'أرض':
        return Column(children: [
          TextFormField(
            controller: _spaceController,
            decoration: InputDecoration(
                labelText: 'المساحة (متر مربع)',
                labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال المساحة بالمتر المربع';
              }
              return null;
            },
          ),
          _buildCounterField(
            label: "عدد الشوارع المحيطه",
            value: _streetsCount,
            onIncrement: () {
              setState(() {
                _streetsCount++;
              });
            },
            onDecrement: () {
              setState(() {
                _streetsCount--;
              });
            },
            emoji: '🛣️',
          ),
        ]);
      case 'محل':
        return Column(
          children: [
            TextFormField(
              controller: _spaceController,
              decoration: InputDecoration(
                  labelText: 'المساحة (متر مربع)',
                  labelStyle: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                  )),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال المساحة بالمتر المربع';
                }
                return null;
              },
            ),
          ],
        );
      case 'مكتب':
      case 'مصنع':
      case 'جناح فندقي':
      case 'ملعب كرة قدم':
      case 'مكان حفلات الزفاف':
      default:
        return Container();
    }
  }

  Widget _buildCityDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCity,
      items: [
        'طرابلس',
        'بنغازي',
        'مصراتة',
        // Add other cities as needed
      ].map((String city) {
        return DropdownMenuItem<String>(
          value: city,
          child: Text(city,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
              )),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCity = newValue!;
        });
      },
      decoration: InputDecoration(
        labelText: 'المدينة',
        labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى اختيار المدينة';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("نشر عقارات",
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                  labelText: 'العنوان',
                  labelStyle: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                  )),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال العنوان';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _propertyType,
              items: ['إيجار', 'بيع'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                      )),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _propertyType = newValue!;
                });
              },
              decoration: InputDecoration(
                  labelText: 'نوع المعاملة',
                  labelStyle: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                  )),
            ),
            DropdownButtonFormField<String>(
              value: _propertyCategory,
              items: [
                'منزل',
                'شقة',
                'أرض',
                'منزل العطلة',
                'محل',
                'مكتب',
                'مصنع',
                'جناح فندقي',
                'ملعب كرة قدم',
                'مكان حفلات الزفاف',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                      )),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _propertyCategory = newValue!;
                });
              },
              decoration: InputDecoration(
                  labelText: 'فئة العقار',
                  labelStyle: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                  )),
            ),
            if (_propertyType == 'إيجار')
              Column(
                children: [
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                        labelText: 'السعر',
                        labelStyle: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                        )),
                    keyboardType: TextInputType.number,
                   
                  ),
                  DropdownButtonFormField<String>(
                    value: _rentType,
                    items: ['يومي', 'شهري', 'سنوي'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                            )),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _rentType = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: 'نوع الإيجار',
                        labelStyle: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  _buildCustomCheckboxListTile(
                    title: 'قابل للتفاوض',
                    value: _isNegotiable,
                    onChanged: (bool? value) {
                      setState(() {
                        _isNegotiable = value!;
                      });
                    },
                    emoji: '💬',
                  ),
                ],
              ),
            if (_propertyType == 'بيع')
              Column(
                children: [
                  TextFormField(
                    controller: _minPriceController,
                    decoration: InputDecoration(
                        labelText: 'السعر الأدنى',
                        labelStyle: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                        )),
                    keyboardType: TextInputType.number,
                     
                  ),
                     _buildCustomCheckboxListTile(
                    title: 'قابل للتفاوض',
                    value: _isNegotiable,
                    onChanged: (bool? value) {
                      setState(() {
                        _isNegotiable = value!;
                      });
                    },
                    emoji: '💬',
                  ),
                

                  TextFormField(
                    controller: _maxPriceController,
                    decoration: InputDecoration(
                        labelText: 'السعر الأقصى',
                        labelStyle: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                        )),
                    keyboardType: TextInputType.number,
                    
                  ),
                ],
              ),
              
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                  labelText: 'الوصف',
                  labelStyle: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                  )),
              maxLines: 3,
              
            ),
            DropdownButtonFormField<String>(
              value: _selectedCity,
              decoration: InputDecoration(
                labelText: 'المدينة',
                labelStyle: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCity = newValue!;
                });
              },
              items: _cities.map<DropdownMenuItem<String>>((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city,
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                      )),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            _buildPropertySpecificFields(),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromARGB(255, 59, 0, 223),
              ),
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 1, 39, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('التالي',
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      textStyle:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    )),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
