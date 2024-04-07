import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:studenthelp/Models/ProjectModel.dart';
import 'package:studenthelp/components/AddProjectScreen.dart';
import 'package:studenthelp/settings/theme_provider.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailsScreen({Key? key, required this.project})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current user ID from Firebase Auth
    String? currentUserID = FirebaseAuth.instance.currentUser?.uid;
    print(currentUserID);
    print(project.userId);
    return Consumer<ThemeStateProvider>(builder: (context, theme, child) {
      return CupertinoApp(
        theme: CupertinoThemeData(
          brightness: theme.isDarkTheme ? Brightness.dark : Brightness.light,
          primaryColor: CupertinoColors.activeBlue, // iPhone-like blue color
        ),
        home: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(project.title),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.0),
                _buildDetailRow("Description:", project.description),
                _buildDetailRow("Tech Stack:", project.techStack),
                _buildDetailRow(
                    "Team Members:", project.teamMembers.join(", ")),
                _buildDetailRow("Faculty Guide:", project.facultyGuide),
                _buildDetailRow("Drive Link:", project.driveLink ?? 'N/A'),
                _buildDetailRow(
                    "GitHub Repo Link:", project.gitRepoLink ?? 'N/A'),
                // Show the "Edit Project" button only if the current user is the owner of the project
                if (currentUserID == project.userId)
                  CupertinoButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => AddProjectScreen(
                            onProjectAdded: (editedProject) {
                              // Handle updated project if needed
                              // update the list of projects
                            },
                            project:
                                project, // Pass the current project for editing
                          ),
                        ),
                      );
                    },
                    child: Text("Edit Project"),
                  )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDetailRow(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.0),
        Text(
          title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.0),
        Text(
          content,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 8.0),
        Divider(
          color: Colors.grey,
        )
      ],
    );
  }
}
