class Mentor {
  final String name;
  final String userId;
  final List<String> mentees;
  final List<String> requests;

  Mentor({
    required this.userId,
    required this.name,
    required this.mentees,
    required this.requests,
  });

  factory Mentor.fromMap(Map<String, dynamic> map) {
    return Mentor(
      userId: map['userId'],
      mentees: List<String>.from(map['mentees']),
      requests: List<String>.from(map['requests']),
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'mentees': mentees,
      'requests': requests,
      'name': name,
    };
  }
}
