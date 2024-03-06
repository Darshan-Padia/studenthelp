class Question {
  final String id;
  final String title;
  final String body;

  Question({
    required this.id,
    required this.title,
    required this.body,
  });

  // Constructor to initialize a Question object from a map
  Question.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        body = map['body'];
}

class Answer {
  final String body;
  final String userId;

  Answer({required this.body, required this.userId});

  // Constructor to initialize an Answer object from a map
  Answer.fromMap(Map<String, dynamic> map)
      : body = map['body'],
        userId = map['userId'];
}
