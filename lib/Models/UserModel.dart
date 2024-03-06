class Userr {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String organization;
  final String profession;
  final List<String> skills;
  final String city;
  final String pseudonym;

  Userr({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.organization,
    required this.profession,
    required this.skills,
    required this.city,
    required this.pseudonym,
  });

  factory Userr.fromJson(Map<String, dynamic> json) {
    return Userr(
      id: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      organization: json['organization'] ?? '',
      profession: json['profession'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      city: json['city'] ?? '',
      pseudonym: json['pseudonym'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'organization': organization,
      'profession': profession,
      'skills': skills,
      'city': city,
      'pseudonym': pseudonym,
    };
  }
}
