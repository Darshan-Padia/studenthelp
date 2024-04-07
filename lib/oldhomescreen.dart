import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studenthelp/components/AluminiAddPage.dart';
import 'package:studenthelp/components/BooksHomepage.dart';
import 'package:studenthelp/components/Iphone.dart';
import 'package:studenthelp/components/Mentor_Mentee.dart';
import 'package:studenthelp/components/ProjectsMainScreen.dart';
import 'package:studenthelp/components/SearchAlumini.dart';
import 'package:studenthelp/components/login.dart';
import 'package:studenthelp/components/profile.dart';
import 'package:studenthelp/components/signup.dart';
import 'package:studenthelp/components/StudentCommunityForumPage.dart';

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
          IconButton(
            onPressed: () {
              // Navigate to profile page with smooth transition
              Get.to(() => ProfileScreen(), transition: Transition.fade);
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              // Toggle theme
            },
            icon: const Icon(Icons.dark_mode_outlined),
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAll(LoginScreen());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Display two cards in each row
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildCard(
              title: 'Student Community Forum',
              onTap: () {
                // Navigate to StudentCommunityForumPage with smooth transition
                Get.to(
                  () => StudentCommunityForumPage(),
                  transition: Transition.cupertino,
                );
              },
            ),
            _buildCard(
              title: 'Alumni Add Page',
              onTap: () {
                // Navigate to AlumniAddPage with smooth transition
                Get.to(
                  () => AlumniAddPage(),
                  transition: Transition.cupertino,
                );
              },
            ),
            _buildCard(
              title: 'Search Alumni',
              onTap: () {
                // Navigate to SearchAlumniPage with smooth transition
                Get.to(
                  () => SearchAlumniPage(),
                  transition: Transition.cupertino,
                );
              },
            ),
            _buildCard(
              title: 'Mentor Mentee',
              onTap: () {
                // Navigate to MentorMentee with smooth transition
                Get.to(
                  () => MentorMentee(),
                  transition: Transition.cupertino,
                );
              },
            ),
            _buildCard(
              title: 'Projects',
              onTap: () {
                // Navigate to ProjectsMainScreen with smooth transition
                Get.to(() => ProjectMainScreen(),
                    transition: Transition.cupertino);
              },
            ),
            _buildCard(
                title: "iphone",
                onTap: () {
                  Get.to(
                    () => IphoneScreen(),
                    transition: Transition.cupertino,
                  );
                }),
            _buildCard(
                title: "signup",
                onTap: () {
                  Get.to(
                    () => SignUpScreen(),
                    transition: Transition.rightToLeft,
                  );
                }),
            // _buildCard(
            //   title: 'Books and Notes',
            //   onTap: () {
            //     // Navigate to ProjectsMainScreen with smooth transition
            //     Get.to(() => BooksScreen(), transition: Transition.fadeIn);
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        splashColor: const Color.fromARGB(
            255, 192, 210, 240), // Set splash color to blue
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
