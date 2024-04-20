import 'package:flutter/cupertino.dart';
import 'package:studenthelp/widgets/text_field.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studenthelp/Models/ProjectModel.dart';
import 'package:studenthelp/helper/firebase_helper.dart';
import 'package:get/get.dart';
class AddProjectScreen extends StatefulWidget {
  final Function(Project) onProjectAdded;
  final Project? project; // Nullable Project to edit if not null
  const AddProjectScreen({
    Key? key,
    required this.onProjectAdded,
    this.project, // Nullable project parameter
  }) : super(key: key);

  @override
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController techStackController;
  late TextEditingController teamMembersController;
  late TextEditingController facultyGuideController;
  late TextEditingController driveLinkController;
  late TextEditingController gitRepoLinkController;
  late TextEditingController semesterController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with project data if provided
    titleController = TextEditingController(text: widget.project?.title ?? '');
    descriptionController =
        TextEditingController(text: widget.project?.description ?? '');
    techStackController =
        TextEditingController(text: widget.project?.techStack ?? '');
    teamMembersController = TextEditingController(
        text: widget.project?.teamMembers.join(', ') ?? '');
    facultyGuideController =
        TextEditingController(text: widget.project?.facultyGuide ?? '');
    driveLinkController =
        TextEditingController(text: widget.project?.driveLink ?? '');
    gitRepoLinkController =
        TextEditingController(text: widget.project?.gitRepoLink ?? '');
    semesterController =
        TextEditingController(text: widget.project?.semester ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return 
    CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Add Project'),
      ),
      child: SafeArea(

        child: 
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextFieldBuilder(
                      label: 'Title',
                      controller: titleController,
                    ),
                    
                    const SizedBox(height: 20.0),
                    CustomTextFieldBuilder(
                      label: 'Description',
                      controller: descriptionController,
                    ),
                    const SizedBox(height: 10.0),
                    CustomTextFieldBuilder(
                      label: 'Tech Stack',
                      controller: techStackController,
                    ),
                    const SizedBox(height: 10.0),
                    CustomTextFieldBuilder(
                      label: 'Team Members',
                      controller: teamMembersController,
                    ),
                    const SizedBox(height: 10.0),
                    CustomTextFieldBuilder(
                      label: 'Faculty Guide',
                      controller: facultyGuideController,
                    ),
                    const SizedBox(height: 10.0),
                    CustomTextFieldBuilder(
                      label: 'Drive Link',
                      controller: driveLinkController,
                    ),
                    const SizedBox(height: 10.0),
                    CustomTextFieldBuilder(
                      label: 'Git Repo Link',
                      controller: gitRepoLinkController,
                    ),
                    const SizedBox(height: 10.0),
                    CustomTextFieldBuilder(
                      label: 'Semester',
                      controller: semesterController,
                    ),
                    const SizedBox(height: 10.0),
          
                    Center(
                      child: CupertinoButton.filled(
                        onPressed: () async {
                          if (_validateInputs()) {
                            Project updatedProject = _createProject();
                            if (widget.project != null) {
                              // If it's an edit operation, update project
                              await FirebaseHelper().updateProject(
                                projectId: updatedProject.projectId,
                                title: updatedProject.title,
                                description: updatedProject.description,
                                techStack: updatedProject.techStack,
                                teamMembers: updatedProject.teamMembers,
                                facultyGuide: updatedProject.facultyGuide,
                                driveLink: updatedProject.driveLink,
                                gitRepoLink: updatedProject.gitRepoLink,
                                semester: updatedProject.semester,
                              );
                            } else {
                              // If it's an add operation, add project
                              await FirebaseHelper().addProject(
                                projectId: updatedProject.projectId,
                                userId: updatedProject.userId,
                                title: updatedProject.title,
                                description: updatedProject.description,
                                techStack: updatedProject.techStack,
                                teamMembers: updatedProject.teamMembers,
                                facultyGuide: updatedProject.facultyGuide,
                                driveLink: updatedProject.driveLink,
                                gitRepoLink: updatedProject.gitRepoLink,
                                semester: updatedProject.semester,
                              );
                            }
                            widget.onProjectAdded(updatedProject);
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                            widget.project != null ? 'Edit Done' : 'Add Project'),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Project _createProject() {
    return Project(
      projectId: widget.project?.projectId ??
          'project${DateTime.now().millisecondsSinceEpoch}',
      userId: FirebaseAuth.instance.currentUser!.uid,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      techStack: techStackController.text.trim(),
      teamMembers: teamMembersController.text
          .trim()
          .split(',')
          .map((e) => e.trim())
          .toList(),
      facultyGuide: facultyGuideController.text.trim(),
      driveLink: driveLinkController.text.trim(),
      gitRepoLink: gitRepoLinkController.text.trim(),
      semester: semesterController.text.trim(),
    );
  }

  bool _validateInputs() {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        techStackController.text.trim().isEmpty ||
        teamMembersController.text.trim().isEmpty ||
        facultyGuideController.text.trim().isEmpty ||
        semesterController.text.trim().isEmpty) {
      // show get snackbar
      Get.snackbar('Error', 'Please fill all the fields',
          backgroundColor: Colors.red);
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    
    titleController.dispose();
    descriptionController.dispose();
    techStackController.dispose();
    teamMembersController.dispose();
    facultyGuideController.dispose();
    driveLinkController.dispose();
    gitRepoLinkController.dispose();
    semesterController.dispose();
    super.dispose();
  }
}
