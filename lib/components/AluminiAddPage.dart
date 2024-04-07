import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:studenthelp/helper/firebase_helper.dart';
import 'package:studenthelp/settings/theme_provider.dart';
import 'package:studenthelp/widgets/text_field.dart'; // Assuming you have a custom TextField widget

class AlumniAddPage extends StatefulWidget {
  const AlumniAddPage({super.key});

  @override
  State<AlumniAddPage> createState() => _AlumniAddPageState();
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  // final profilePhotoUrl = '';
  Map<String, dynamic>? profileDetails;
  bool isLoading = false;

  bool isEverythingFilled() {
    // Check if all required fields are filled
    return profileDetails != null &&
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        companyNameController.text.isNotEmpty &&
        skillsController.text.isNotEmpty &&
        headlineController.text.isNotEmpty &&
        summaryController.text.isNotEmpty;
  }

  Future<void> _addAlumniToDatabase() async {
    // Trim whitespace from phone number
    final String trimmedPhone = phoneController.text.trim();

    // Check if phone number has 10 digits
    if (trimmedPhone.length != 10) {
      Get.snackbar('Error', 'Please enter a valid phone number',
          backgroundColor: Colors.red);
      return;
    }

    // Check if email is in correct format
    final String email = emailController.text.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      Get.snackbar('Error', 'Please enter a valid email address',
          backgroundColor: Colors.red);
      return;
    }

    // Convert all text inputs to lowercase
    final String firstName = firstNameController.text.toLowerCase();
    final String lastName = lastNameController.text.toLowerCase();
    final String companyName = companyNameController.text.toLowerCase();
    final List<String> skills = skillsController.text
        .toLowerCase()
        .split(',')
        .map((e) => e.trim())
        .toList();
    final String headline = headlineController.text.toLowerCase();
    final String summary = summaryController.text.toLowerCase();

    // Check if all required fields are filled
    if (isEverythingFilled()) {
      try {
        // Call the FirebaseHelper method to add alumni
        final String alumniId = await FirebaseHelper().addAlumni(
          firstName: firstName,
          lastName: lastName,
          companyName: companyName,
          skills: skills,
          headline: headline,
          summary: summary,
          profilePhotoUrl: profileDetails!['profile_photo_url'] ?? '',
          email: email,
          phone: trimmedPhone,
        );

        if (alumniId.isNotEmpty) {
          // Alumni added successfully
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Alumni added successfully'),
              backgroundColor: Colors.green,
            ),
          );
          print('Alumni added with ID: $alumniId');
          // Optionally, you can perform additional actions or navigate to another page
        } else {
          // Handle error while adding alumni
          print('Error adding alumni to database');
        }
      } catch (e) {
        // Handle exceptions
        print('Exception while adding alumni: $e');
      }
    } else {
      // Handle case when not all required fields are filled
      Get.snackbar('Error', 'Please fill in all required fields',
          backgroundColor: Colors.red);
      print('Please fill in all required fields');
    }
  }

  Future<void> _searchPeople() async {
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
      Uri.parse('http://192.168.16.35:5000/get_profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'linkedin_username': linkedinUsername}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        profileDetails = data;
        print("profileDetails: $profileDetails");
        isLoading = false;
        // Populate text fields with API data
        firstNameController.text = profileDetails!['first_name'] ?? '';
        lastNameController.text = profileDetails!['last_name'] ?? '';
        companyNameController.text = profileDetails!['company_name'] ?? '';
        skillsController.text = profileDetails!['skills'] != null
            ? profileDetails!['skills'].join(', ')
            : '';
        headlineController.text = profileDetails!['headline'] ?? '';
        summaryController.text = profileDetails!['summary'] ?? '';
        emailController.text = profileDetails!['email'] ?? '';
        phoneController.text = profileDetails!['phone'] ?? '';
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Handle error
      ;
      Get.snackbar('Error', 'Unable to fetch profile details',
          backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Add Alumni'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextFieldBuilder(
                  controller: linkedinUsernameController,
                  label: 'LinkedIn Username',
                ),
                CupertinoButton.filled(
                  onPressed: _searchPeople,
                  child:
                      isLoading ? CupertinoActivityIndicator() : Text('Search'),
                ),
                CustomTextFieldBuilder(
                  controller: firstNameController,
                  label: 'First Name',
                ),
                CustomTextFieldBuilder(
                  controller: lastNameController,
                  label: 'Last Name',
                ),
                CustomTextFieldBuilder(
                  controller: companyNameController,
                  label: 'Company Name',
                ),
                CustomTextFieldBuilder(
                  controller: skillsController,
                  label: 'Skills',
                ),
                CustomTextFieldBuilder(
                  controller: headlineController,
                  label: 'Headline',
                ),
                CustomTextFieldBuilder(
                  controller: summaryController,
                  label: 'Summary',
                ),
                CustomTextFieldBuilder(
                  controller: emailController,
                  label: 'Email',
                ),
                CustomTextFieldBuilder(
                  controller: phoneController,
                  label: 'Phone',
                ),
                CupertinoButton.filled(
                  onPressed: _addAlumniToDatabase,
                  child: Text('Add'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
