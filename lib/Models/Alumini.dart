class Alumni {
  final String id;
  final String firstName;
  final String lastName;
  final String companyName;
  final List<String> skills;
  final String headline;
  final String summary;
  final String profile_photo_url;

  Alumni({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.companyName,
    required this.skills,
    required this.headline,
    required this.summary,
    required this.profile_photo_url,
  });

  factory Alumni.fromMap(Map<String, dynamic> map) {
    return Alumni(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      companyName: map['companyName'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      headline: map['headline'] ?? '',
      summary: map['summary'] ?? '',
      profile_photo_url: map['profile_photo_url'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'companyName': companyName,
      'skills': skills,
      'headline': headline,
      'summary': summary,
      'profile_photo_url': profile_photo_url,
    };
  }
}
