import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studenthelp/Models/ProjectModel.dart';
import 'package:studenthelp/helper/firebase_helper.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project != null ? 'Edit Project' : 'Add Project'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            _buildTextField(titleController, 'Title', TextInputType.text),
            SizedBox(height: 16.0),
            _buildTextField(
                descriptionController, 'Description', TextInputType.multiline),
            SizedBox(height: 16.0),
            _buildTextField(
                techStackController, 'Tech Stack', TextInputType.text),
            SizedBox(height: 16.0),
            _buildTextField(
                teamMembersController, 'Team Members', TextInputType.text),
            SizedBox(height: 16.0),
            _buildTextField(
                facultyGuideController, 'Faculty Guide', TextInputType.text),
            SizedBox(height: 16.0),
            _buildTextField(
                driveLinkController, 'Drive Link', TextInputType.url),
            SizedBox(height: 16.0),
            _buildTextField(
                gitRepoLinkController, 'GitHub Repo Link', TextInputType.url),
            SizedBox(height: 16.0),
            _buildTextField(semesterController, 'Semester', TextInputType.text),
            SizedBox(height: 16.0),
            Center(
                child:
                    //  ElevatedButton(
                    //   onPressed: () async {
                    //     if (_validateInputs()) {
                    //       Project updatedProject = _createProject();
                    //       if (widget.project != null) {
                    //         // If it's an edit operation, update project
                    //         await FirebaseHelper().updateProject(
                    //           projectId: updatedProject.projectId,
                    //           title: updatedProject.title,
                    //           description: updatedProject.description,
                    //           techStack: updatedProject.techStack,
                    //           teamMembers: updatedProject.teamMembers,
                    //           facultyGuide: updatedProject.facultyGuide,
                    //           driveLink: updatedProject.driveLink,
                    //           gitRepoLink: updatedProject.gitRepoLink,
                    //           semester: updatedProject.semester,
                    //         );
                    //       } else {
                    //         // If it's an add operation, add project
                    //         await FirebaseHelper().addProject(
                    //           projectId: updatedProject.projectId,
                    //           userId: updatedProject.userId,
                    //           title: updatedProject.title,
                    //           description: updatedProject.description,
                    //           techStack: updatedProject.techStack,
                    //           teamMembers: updatedProject.teamMembers,
                    //           facultyGuide: updatedProject.facultyGuide,
                    //           driveLink: updatedProject.driveLink,
                    //           gitRepoLink: updatedProject.gitRepoLink,
                    //           semester: updatedProject.semester,
                    //         );
                    //       }
                    //       widget.onProjectAdded(updatedProject);
                    //       Navigator.pop(context);
                    //     }
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8.0),
                    //     ),
                    //   ),
                    //   child:
                    //       Text(widget.project != null ? 'Edit Done' : 'Add Project'),
                    // ),
                    CupertinoButton.filled(
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
              child: Text(widget.project != null ? 'Edit Done' : 'Add Project'),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      TextInputType inputType) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      keyboardType: inputType,
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all required fields'),
      ));
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
