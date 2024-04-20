import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studenthelp/Models/Mentor.dart';
import 'package:studenthelp/helper/firebase_helper.dart';

class MenteeScreen extends StatefulWidget {
  @override
  _MenteeScreenState createState() => _MenteeScreenState();
}

//       Column(
//         children: [
//           DropdownButton<String>(
//             value: selectedMentor,
//             items: mentorsList
//                 .map((mentor) => DropdownMenuItem(
//                       child: Text(mentor.name),
//                       value: mentor.name,
//                     ))
//                 .toList(),
//             onChanged: (value) {
//               setState(() {
//                 selectedMentorId = mentorsList
//                     .firstWhere((mentor) => mentor.name == value)
//                     .userId;
//                 selectedMentor = value!;
//                 print(selectedMentor);
//               });
//             },
//           ),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 approved = 'pending';
//                 print("pendinggg");
//                 print(selectedMentorId);
//                 FirebaseHelper().updateMentorRequests(
//                   selectedMentorId,
//                   FirebaseAuth.instance.currentUser!.uid,
//                 );
//                 FirebaseHelper().updateUserApprovedStatus(
//                   FirebaseAuth.instance.currentUser!.uid,
//                   approved,
//                 );
//               });
//               // Logic to send mentor request
//             },
//             child: Text('Send Mentor Request'),
//           ),
//         ],
//       ),
//     if (!isTeacher && !isMentor && approved == 'pending')
//       Text(
//         'Your mentor request is pending approval.',
//         style: TextStyle(color: Colors.orange),
//       ),
//     if (!isTeacher && isMentor)
//       Text(
//         'You are a mentor. You need to approve mentee requests.',
//         style: TextStyle(color: Colors.grey),
//       ),
//     if (approved == 'true')
//       Text(
//         'Mentor Approved. You can now access the content.',
//         style: TextStyle(color: Colors.green),
//       ),
//   ],
// ),

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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Mentee screen'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    CupertinoButton.filled(
                      child: Text(
                        'Select Mentor',
                        style: TextStyle(
                          color: Colors.white, // Set button text color to white
                        ),
                      ),
                      onPressed: () {
                        showCupertinoModalPopup(
                          // mentor list
                          context: context,
                          builder: (context) {
                            return CupertinoActionSheet(
                              title: Text('Select Mentor'),
                              actions: mentorsList
                                  .map(
                                    (mentor) => CupertinoActionSheetAction(
                                      onPressed: () {
                                        setState(() {
                                          selectedMentorId = mentor.userId;
                                          selectedMentor = mentor.name;
                                          print(selectedMentor);
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text(mentor.name),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    CupertinoButton(
                      color: approved == 'pending'
                          ? CupertinoColors.systemGrey
                          : CupertinoColors.systemBlue,
                      onPressed: () {
                        

                        // Logic to send mentor request

                        approved == 'false'?
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
                        }):
                        null;

                      },
                      child: 
                      approved == 'pending'
                          ? Text('Request Pending')
                          : Text('Send Mentor Request'),

                      
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    if (!isTeacher && !isMentor && approved == 'pending')
                      Text(
                        'Your mentor request is pending approval.',
                        style: TextStyle(color: CupertinoColors.systemOrange),
                      ),
                    if (!isTeacher && isMentor)
                      Text(
                        'You are a mentor. You need to approve mentee requests.',
                        style: TextStyle(color: CupertinoColors.systemGrey),
                      ),
                    if (approved == 'true')
                      Text(
                        'Mentor Approved. You can now access the content.',
                        style: TextStyle(color: CupertinoColors.systemGreen),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
