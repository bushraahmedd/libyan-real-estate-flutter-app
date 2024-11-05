class Property {
  final String city;
  final String category;
  final String title;
  final String description;
  final String location;
  final String type;
  final double price;
  final bool negotiable;
  final bool furnished;
  final bool hasGarden;
  // Add more fields as needed

  Property({
    required this.city,
    required this.category,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    required this.price,
    required this.negotiable,
    required this.furnished,
    required this.hasGarden,
    // Initialize other fields
  });
}
