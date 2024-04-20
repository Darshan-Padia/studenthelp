import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:studenthelp/Models/Mentor.dart';
import 'package:studenthelp/Models/UserModel.dart';
import 'package:studenthelp/components/Mentee.dart';
import 'package:studenthelp/components/Mentor.dart';
import 'package:studenthelp/helper/firebase_helper.dart'; // Import FirebaseAuth

class MentorMentee extends StatefulWidget {
  @override
  _MentorMenteeState createState() => _MentorMenteeState();
}


class _MentorMenteeState extends State<MentorMentee> {
  Userr? _user; // Declare a variable to hold user data
  bool _isLoading = true; // Flag to track loading state

  @override
  void initState() {
    super.initState();
    _getUserData(); // Call function to get user data when the screen initializes
  }

  // Function to get user data from Firebase
  void _getUserData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    Userr? userData = await FirebaseHelper().getUserData(userId);
    setState(() {
      _user = userData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Your Screen'),
      ),
      child: _isLoading
          ? Center(child: CupertinoActivityIndicator() )
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    // Check if user data is available
    if (_user != null) {
      // Check if the user's profession is 'teacher'
      bool isTeacher = _user!.profession.toLowerCase() == 'teacher';

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton(
              onPressed: isTeacher ? null : _navigateToMenteeScreen,
              child: Text(isTeacher ? 'Mentee (Disabled)' : 'Mentee'),
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              onPressed: isTeacher ? _navigateToMentorScreen : null,
              child: Text(isTeacher ? 'Mentor' : 'Mentor (Disabled)'),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text('User data not found'),
      );
    }
  }

  // Function to navigate to the mentee screen
  void _navigateToMenteeScreen() {
    // Implement navigation logic to the mentee screen
    Get.to(MenteeScreen());
  }

  // Function to navigate to the mentor screen
  void _navigateToMentorScreen() {
    Get.to(MentorScreen());
  }
}