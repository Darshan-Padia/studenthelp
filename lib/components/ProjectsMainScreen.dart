
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:studenthelp/Models/ProjectModel.dart';
import 'package:studenthelp/components/AddProjectScreen.dart';
import 'package:studenthelp/components/ProjectDetailsScreeen.dart';
import 'package:studenthelp/helper/firebase_helper.dart';
import 'package:studenthelp/settings/theme_config.dart';
import 'package:studenthelp/settings/theme_provider.dart'; // Import ThemeConfig

class ProjectMainScreen extends StatefulWidget {
  const ProjectMainScreen({Key? key}) : super(key: key);

  @override
  State<ProjectMainScreen> createState() => _ProjectMainScreenState();
}

class _ProjectMainScreenState extends State<ProjectMainScreen> {
  late List<Project> projects = []; // List to hold projects
  late Future<List<Project>> projectList;
  late TextEditingController searchController;
  late String searchValue;

  @override
  void initState() {
    super.initState();
    fetchProjects();
    searchController = TextEditingController();
    searchValue = 'Title'; // default search value
  }

  // Function to fetch all projects from Firestore
  Future<void> fetchProjects() async {
    projectList = FirebaseHelper().getAllProjects();
    projectList.then((value) {
      setState(() {
        projects = value;
      });
      print(projects.length);
    });
  }

  final List<String> searchOptions = [
    'Title',
    'Tech Stack',
    'Faculty Guide',
    'Team Member',
  ];
  // Function to filter projects based on search criteria
  List<Project> filterProjects(String query) {
    query = query.toLowerCase();
    return projects.where((project) {
      switch (searchValue) {
        case 'Title':
          return project.title.toLowerCase().contains(query);
        case 'Tech Stack':
          return project.techStack.toLowerCase().contains(query);
        case 'Faculty Guide':
          return project.facultyGuide.toLowerCase().contains(query);
        case 'Team Member':
          return project.teamMembers
              .any((member) => member.toLowerCase().contains(query));
        default:
          return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeStateProvider>(builder: (context, theme, child) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Projects'),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 10),
              CupertinoSearchTextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {});
                },
                placeholder: 'Search',
              ),
              SizedBox(height: 10),
              Text(
                'Search by: $searchValue',
                style: TextStyle(
                  color: theme.isDarkTheme ? Colors.white : Colors.black,
                  fontSize: 16, // Adjust the font size as needed
                  fontWeight: FontWeight.normal, // Set to normal weight
                  decoration: TextDecoration.none, // Remove underline
                ),
              ),
              SizedBox(height: 6),
              CupertinoButton.filled(
                child: Text(
                  'Select Search Criteria',
                  style: TextStyle(
                    color: Colors.white, // Set button text color to white
                  ),
                ),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      title: Text('Select an Option'),
                      message: Text('Choose from the list'),
                      actions: searchOptions
                          .map((option) => CupertinoActionSheetAction(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    color: theme.isDarkTheme
                                        ? Colors.white
                                        : Colors.blueGrey,
                                    fontSize:
                                        21, // Adjust the font size as needed
                                    fontWeight: FontWeight
                                        .normal, // Set to normal weight
                                    decoration:
                                        TextDecoration.none, // Remove underline
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    searchValue = option;
                                  });
                                  Navigator.pop(context);
                                },
                              ))
                          .toList(),
                      cancelButton: CupertinoActionSheetAction(
                        child:
                            // Cancel button
                            Text(
                          'Cancel',
                          style: TextStyle(
                            color: theme.isDarkTheme
                                ? Colors.grey
                                : Colors.blueGrey,
                            fontSize: 21, // Adjust the font size as needed
                            fontWeight:
                                FontWeight.normal, // Set to normal weight
                            decoration: TextDecoration.none, // Remove underline
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              Expanded(
                child: projects.isEmpty
                    ? Center(child: CupertinoActivityIndicator())
                    : filterProjects(searchController.text).isNotEmpty
                        ? CupertinoListSection(
                            children: filterProjects(searchController.text)
                                .map((project) => CupertinoListTile(
                                      leadingSize: 60,
                                      title: Text(
                                        project.title,
                                        style: TextStyle(
                                          color: theme.isDarkTheme
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      subtitle: Text(
                                        project.techStack,
                                        style: TextStyle(
                                          color: theme.isDarkTheme
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      trailing:
                                          Icon(CupertinoIcons.right_chevron),
                                      onTap: () {
                                        Get.to(
                                          () => ProjectDetailsScreen(
                                            project: project,
                                          ),
                                          transition: Transition.cupertino,
                                        );
                                      },
                                    ))
                                .toList(),
                          )
                        : Center(
                            child: Text(
                              'No projects found',
                              style: TextStyle(
                                color: theme.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
              ),
              // adding button ( like a floating button ) of add projects taht redirects to  AddProjectScreen
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CupertinoButton.filled(
                  child: Text('Add Project',
                      style: TextStyle(
                          color:
                              Colors.white)), // Set button text color to white
                  onPressed: () {
                    Get.to(
                      () => AddProjectScreen(
                        onProjectAdded: (project) {
                          setState(() {
                            projects.add(project);
                          });
                        },
                      ),
                      transition: Transition.cupertino,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
