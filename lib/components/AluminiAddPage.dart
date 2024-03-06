import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:studenthelp/settings/theme_provider.dart';
import 'package:studenthelp/widgets/text_field.dart'; // Assuming you have a custom TextField widget

class AlumniAddPage extends StatefulWidget {
  @override
  _AlumniAddPageState createState() => _AlumniAddPageState();
}

class _AlumniAddPageState extends State<AlumniAddPage> {
  final TextEditingController linkedinUsernameController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController headlineController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();

  Map<String, dynamic>? profileDetails;
  bool isLoading = false;

  bool isAddButtonEnabled() {
    // Check if all required fields are filled
    return profileDetails != null &&
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        companyNameController.text.isNotEmpty &&
        skillsController.text.isNotEmpty &&
        headlineController.text.isNotEmpty &&
        summaryController.text.isNotEmpty;
  }

  Future<void> _addAlumni() async {
    final String linkedinUsername = linkedinUsernameController.text.trim();
    // remove unnecessary spaces from the username
    if (linkedinUsername.isEmpty) {
      // Handle empty username
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://192.168.170.35:5000/get_profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'linkedin_username': linkedinUsername}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        profileDetails = data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Unable to fetch profile details'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeStateProvider>(builder: (context, theme, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Add Alumni'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              if (profileDetails != null) ...[
                CircleAvatar(
                  backgroundColor:
                      theme.isDarkTheme ? Colors.grey[800] : Colors.grey[200],
                  radius: 110,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(
                        profileDetails!['profile_photo_url'] ?? ''),
                  ),
                ),
                SizedBox(height: 20),
                CustomTextFieldBuilder().buildTextField(
                  'First Name',
                  firstNameController,
                ),
                CustomTextFieldBuilder().buildTextField(
                  'Last Name',
                  lastNameController,
                ),
                CustomTextFieldBuilder().buildTextField(
                  'Company Name',
                  companyNameController,
                ),
                CustomTextFieldBuilder().buildTextField(
                  'Add Skills here',
                  skillsController,
                ),
                CustomTextFieldBuilder().buildTextField(
                  'Headline',
                  headlineController,
                ),
                CustomTextFieldBuilder().buildTextField(
                  'Summary',
                  summaryController,
                ),
              ],
              SizedBox(height: 20),
              CustomTextFieldBuilder().buildTextField(
                'LinkedIn Username',
                linkedinUsernameController,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: isLoading ? null : _addAlumni,
                    child: isLoading
                        ? CircularProgressIndicator() // Show loading indicator
                        : Text('Search Alumni'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: isAddButtonEnabled() ? () {} : null,
                    child: Text('Add Alumni'),
                    style: ElevatedButton.styleFrom(
                      primary:
                          isAddButtonEnabled() ? Colors.green : Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
