import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:studenthelp/Models/Mentor.dart';
import 'package:studenthelp/helper/firebase_helper.dart';

class MenteeScreen extends StatefulWidget {
  @override
  _MenteeScreenState createState() => _MenteeScreenState();
}

class _MenteeScreenState extends State<MenteeScreen> {
  bool isTeacher = false; // Set this based on the user's profession
  bool isMentor = false; // Set this based on the user's role
  String mentorId = ''; // Store the mentor ID
  String approved = 'false'; // Set this based on mentor's approval
  String selectedMentor = ''; // Store the selected mentor
  List<Mentor> mentorsList = [];
  String selectedMentorId = '';

  @override
  void initState() {
    super.initState();
    // Fetch user data when the widget initializes
    fetchUserData();
    fetchMentorList();
  }

  Future<void> fetchMentorList() async {
    // Fetch mentor list from Firebase
    final mentors = await FirebaseHelper().getMentorList();
    setState(() {
      mentorsList = mentors;
      // print(mentors);
      selectedMentorId = mentorsList.first.userId;
      selectedMentor = mentorsList.first.name;
    });
  }

  Future<void> fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userData = await FirebaseHelper().getUserData(userId);

    if (userData != null) {
      setState(() {
        mentorId = userData.mentorId ?? ''; // Get mentor ID from user data
        approved =
            userData.approved ?? 'false'; // Get approval status from user data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedMentor.isEmpty && mentorsList.isNotEmpty) {
      selectedMentor = mentorsList.first.name;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Mentor-Mentee'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isTeacher)
              Text(
                'You are a teacher. As a teacher, you cannot be a mentee.',
                style: TextStyle(color: Colors.grey),
              ),
            if (!isTeacher && !isMentor && approved == 'false')
              Column(
                children: [
                  DropdownButton<String>(
                    value: selectedMentor,
                    items: mentorsList
                        .map((mentor) => DropdownMenuItem(
                              child: Text(mentor.name),
                              value: mentor.name,
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMentorId = mentorsList
                            .firstWhere((mentor) => mentor.name == value)
                            .userId;
                        selectedMentor = value!;
                        print(selectedMentor);
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        approved = 'pending';
                        print("pendinggg");
                        print(selectedMentorId);
                        FirebaseHelper().updateMentorRequests(
                          selectedMentorId,
                          FirebaseAuth.instance.currentUser!.uid,
                        );
                        FirebaseHelper().updateUserApprovedStatus(
                          FirebaseAuth.instance.currentUser!.uid,
                          approved,
                        );
                      });
                      // Logic to send mentor request
                    },
                    child: Text('Send Mentor Request'),
                  ),
                ],
              ),
            if (!isTeacher && !isMentor && approved == 'pending')
              Text(
                'Your mentor request is pending approval.',
                style: TextStyle(color: Colors.orange),
              ),
            if (!isTeacher && isMentor)
              Text(
                'You are a mentor. You need to approve mentee requests.',
                style: TextStyle(color: Colors.grey),
              ),
            if (approved == 'true')
              Text(
                'Mentor Approved. You can now access the content.',
                style: TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
