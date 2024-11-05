class UserProfile {
  final String uid;
  final String firstName;
  final String secondName;
  final String email;
  final String imageUrl;
  final String address;
  final String number;

  UserProfile({
    required this.uid,
    required this.firstName,
    required this.secondName,
    required this.email,
    required this.imageUrl,
    required this.address,
    required this.number,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'secondName': secondName,
      'email': email,
      'imageUrl': imageUrl,
      'address': address,
      'number': number,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      email: map['email'],
      imageUrl: map['imageUrl'],
      address: map['address'],
      number: map['number'],
    );
  }
}


