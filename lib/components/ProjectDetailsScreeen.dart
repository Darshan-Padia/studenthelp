import 'package:flutter/cupertino.dart';
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

    return Consumer<ThemeStateProvider>(
      builder: (context, theme, child) {
        return CupertinoApp(
          theme: CupertinoThemeData(
            brightness: theme.isDarkTheme ? Brightness.dark : Brightness.light,
            primaryColor: CupertinoColors.activeBlue,
          ),
          home: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(project.title),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    _buildDetailRow(
                        "Description:", project.description, context),
                    _buildDetailRow(
                        "Tech Stack:", project.techStack, context),
                    _buildDetailRow("Team Members:",
                        project.teamMembers.join(", "), context),
                    _buildDetailRow(
                        "Faculty Guide:", project.facultyGuide, context),
                    _buildDetailRow(
                        "Drive Link:", project.driveLink ?? 'N/A', context),
                    _buildDetailRow("GitHub Repo Link:",
                        project.gitRepoLink ?? 'N/A', context),
                    const SizedBox(height: 16.0),
                    // Show the "Edit Project" button only if the current user is the owner of the project
                    if (currentUserID == project.userId)
                      CupertinoButton.filled(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => AddProjectScreen(
                                onProjectAdded: (editedProject) {
                                  // Handle updated project if needed
                                  // update the list of projects
                                },
                                project: project, // Pass the current project for editing
                              ),
                            ),
                          );
                        },
                        child: const Text("Edit Project"),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
      String title, String content, BuildContext context) {
    return Consumer<ThemeStateProvider>(builder: (context, theme, child) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: theme.isDarkTheme
                ? CupertinoColors.white
                : CupertinoColors.black,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          content,
          style: TextStyle(
            fontSize: 16.0,
            // color: CupertinoColors.label,
          ),
        ),
        const SizedBox(height: 16.0),
        // horizontal line
        Container(
          height: 1.0,
          color: theme.isDarkTheme
              ? CupertinoColors.systemGrey5
              : CupertinoColors.systemGrey4,
        ),
      ],
    );
  }
  );
  }
}