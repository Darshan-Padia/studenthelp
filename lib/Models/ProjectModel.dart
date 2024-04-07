class Project {
  final String projectId; // Unique ID for the project
  final String userId; // User ID of the uploader
  final String title;
  final String description;
  final String techStack;
  final List<String> teamMembers;
  final String facultyGuide;
  final String? driveLink; // Optional drive link
  final String? gitRepoLink; // Optional GitHub repository link
  final String semester; // Semester field

  Project({
    required this.projectId,
    required this.userId,
    required this.title,
    required this.description,
    required this.techStack,
    required this.teamMembers,
    required this.facultyGuide,
    required this.semester, // Added semester field
    this.driveLink,
    this.gitRepoLink,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['projectId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      techStack: json['techStack'] ?? '',
      teamMembers: (json['teamMembers'] as List<dynamic>?)
              ?.map((member) => member.toString())
              .toList() ??
          [],
      facultyGuide: json['facultyGuide'] ?? '',
      userId: json['userId'] ?? '',
      driveLink: json['driveLink'],
      gitRepoLink: json['gitRepoLink'],
      semester: json['semester'] ?? '', // Added semester field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'userId': userId,
      'title': title,
      'description': description,
      'techStack': techStack,
      'teamMembers': teamMembers,
      'facultyGuide': facultyGuide,
      'driveLink': driveLink,
      'gitRepoLink': gitRepoLink,
      'semester': semester, // Added semester field
    };
  }
}
