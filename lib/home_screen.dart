import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studenthelp/components/AluminiAddPage.dart';
import 'package:studenthelp/components/login.dart';
import 'package:studenthelp/components/profile.dart';
import 'package:studenthelp/components/signup.dart';
import 'package:studenthelp/components/StudentCommunityForumPage.dart'; // Import StudentCommunityForumPage

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User is not authenticated, redirect to signup page
      return SignUpScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample App'),
        actions: [
          Row(
            children: [
              // profile button
              IconButton(
                onPressed: () {
                  // Navigate to profile page
                  Get.to(ProfileScreen());
                },
                icon: const Icon(Icons.person),
              ),
              IconButton(
                onPressed: () {
                  // Toggle theme
                },
                icon: const Icon(Icons.dark_mode_outlined),
              ),
              // logout button
              IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Get.offAll(LoginScreen());
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Student Community Forum",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Card(
                  elevation: 4,
                  margin: EdgeInsets.all(16),
                  child: InkWell(
                    onTap: () {
                      // Navigate to StudentCommunityForumPage
                      Get.to(StudentCommunityForumPage());
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Open Student Community Forum",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: EdgeInsets.all(16),
                  child: InkWell(
                    onTap: () {
                      // Navigate to StudentCommunityForumPage
                      Get.to(AlumniAddPage());
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Open Alumini add page",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
