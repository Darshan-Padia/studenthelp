import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:studenthelp/components/AluminiAddPage.dart';
import 'package:studenthelp/components/BooksHomepage.dart';
import 'package:studenthelp/components/Iphone.dart';
import 'package:studenthelp/components/MentorMentee.dart';
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
                icon: Icons.book, // Use book icon
              ),
              _buildCard(
                title: 'Projects',
                onTap: () {
                  Get.to(() => ProjectMainScreen());
                },
                icon: Icons.work, // Use work icon
              ),
              _buildCard(
                title: 'Mentor/Mentee',
                onTap: () {
                  Get.to(() => MentorMentee());
                },
                icon: Icons.people, // Use people icon
              ),
              _buildCard(
                title: 'Student Community Forum',
                onTap: () {
                  Get.to(() => StudentCommunityForumPage());
                },
                icon: Icons.forum, // Use forum icon
              ),
              _buildCard(
                title: 'Search Alumini',
                onTap: () {
                  Get.to(() => SearchAlumniPage());
                },
                icon: Icons.search, // Use search icon
              ),
              _buildCard(
                title: 'Alumini Add',
                onTap: () {
                  Get.to(() => AlumniAddPage());
                },
                icon: Icons.add_circle, // Use add_circle icon
              ),
              // _buildCard(
              //   title: 'Iphone',
              //   onTap: () {
              //     // Get.to(() => Iphoone);
              //   },
              //   icon: Icons.phone_iphone, // Use phone_iphone icon
              // ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCard({required String title, required VoidCallback onTap, required IconData icon}) {
    return Consumer<ThemeStateProvider>(builder: (context, theme, child) {
      return CupertinoButton(
        onPressed: onTap,
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: theme.isDarkTheme ? Colors.grey[800] : Colors.grey[200], // Use different background color for light/dark mode
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: theme.isDarkTheme ? Colors.white : Colors.black, // Use different icon color for light/dark mode
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: theme.isDarkTheme ? Colors.white : Colors.black, // Use different text color for light/dark mode
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    });
  }
}