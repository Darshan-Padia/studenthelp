import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
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
import 'package:studenthelp/settings/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User is not authenticated, redirect to signup page
      return SignUpScreen();
    }
    return Consumer<ThemeStateProvider>(builder: (context, theme, child) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          // automaticallyImplyMiddle: true,
          // automaticallyImplyLeading: true,
          leading: const Padding(
            padding: EdgeInsetsDirectional.only(start: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.book),
                SizedBox(width: 8),
                Text(
                  'Student Help',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          trailing: Padding(
            // padding: const EdgeInsetsDirectional.only(bottom: 10),
            padding: EdgeInsets.only(left: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  onPressed: () {
                    // Navigate to profile page with smooth transition
                    Get.to(() => ProfileScreen(), transition: Transition.fade);
                  },
                  child: const Icon(CupertinoIcons.person),
                ),
                CupertinoButton(
                  onPressed: () {
                    // Toggle theme
                  },
                  child: const Icon(CupertinoIcons.moon_stars),
                ),
                CupertinoButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Get.offAll(LoginScreen());
                  },
                  child: const Icon(CupertinoIcons.power),
                ),
              ],
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2, // Display two cards in each row
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            children: [
              _buildCard(
                title: 'Books',
                onTap: () {
                  // Get.to(() => BooksHomepage());
                },
              ),
              _buildCard(
                title: 'Projects',
                onTap: () {
                  Get.to(() => ProjectMainScreen());
                },
              ),
              _buildCard(
                title: 'Mentor/Mentee',
                onTap: () {
                  Get.to(() => MentorMentee());
                },
              ),
              _buildCard(
                title: 'Student Community Forum',
                onTap: () {
                  Get.to(() => StudentCommunityForumPage());
                },
              ),
              _buildCard(
                title: 'Search Alumini',
                onTap: () {
                  Get.to(() => SearchAlumniPage());
                },
              ),
              _buildCard(
                title: 'Alumini Add',
                onTap: () {
                  Get.to(() => AlumniAddPage());
                },
              ),
              _buildCard(
                title: 'Iphone',
                onTap: () {
                  // Get.to(() => Iphoone);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCard({required String title, required VoidCallback onTap}) {
    return Consumer<ThemeStateProvider>(builder: (context, theme, child) {
      return CupertinoButton(
        // elevation: 4,
        // child: InkWell(
        //   onTap: onTap,
        //   splashColor: const Color.fromARGB(
        //       255, 192, 210, 240), // Set splash color to blue
        //   child: Padding(
        //     padding: const EdgeInsets.all(16),
        //     child: Center(
        //       child: Text(
        //         title,
        //         style: const TextStyle(
        //           fontSize: 18,
        //         ),
        //         textAlign: TextAlign.center,
        //       ),
        //     ),
        //   ),
        // ),
        onPressed: onTap,
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // image: DecorationImage(
            //   image: AssetImage('assets/books.jpg'),
            //   fit: BoxFit.cover,
            // ),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                // color: Colors.white,
              ),
            ),
          ),
        ),
      );
    });
  }
}
