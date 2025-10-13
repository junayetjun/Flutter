class Parent {
  final String parentName;
  final String contactPerson;
  final String email;
  final String password;
  final String phone;
  final String address;
  final String childName;
  final String gender;
  final String photo; // ✅ new property for profile photo URL or path

  Parent({
    required this.parentName,
    required this.contactPerson,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.childName,
    required this.gender,
    required this.photo,
  });

  // Convert from JSON
  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      parentName: json['parentName'],
      contactPerson: json['contactPerson'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      address: json['address'],
      childName: json['childName'],
      gender: json['gender'],
      photo: json['photo'] ?? '', // default to empty string if null
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'parentName': parentName,
      'contactPerson': contactPerson,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
      'childName': childName,
      'gender': gender,
      'photo': photo, // include photo in JSON
    };
  }
}
