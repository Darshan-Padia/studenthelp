import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:studenthelp/Models/UserModel.dart';
import 'package:studenthelp/helper/firebase_helper.dart';

class MentorScreen extends StatefulWidget {
  @override
  _MentorScreenState createState() => _MentorScreenState();
}

class _MentorScreenState extends State<MentorScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mentor Dashboard'),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Current Mentees',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return RequestsScreen();
      case 1:
        return CurrentMenteesScreen();
      default:
        return Container();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class RequestsScreen extends StatefulWidget {
  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  List<Userr?> mentorshipRequests = [];
  String mentorId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _fetchMentorshipRequests();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mentorshipRequests.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Row(
            children: [
              Expanded(
                child: Text(mentorshipRequests[index]!.name),
              ),
              IconButton(
                icon: Icon(Icons.check, color: Colors.green),
                onPressed: () {
                  setState(() {
                    // Logic for accepting mentorship request
                    // You can use mentorshipRequests[index] to access user data
                    // changing the approved status of mentee from pending to true
                    // removing the mentee from the mentor's requests list
                    // adding the mentee to the mentor's mentees list
                    FirebaseHelper()
                        .acceptRequest(mentorId, mentorshipRequests[index]!.id);
                    // mentorshipRequests.removeAt(index);
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  setState(() {
                    // Logic for rejecting mentorship request
                    // You can use mentorshipRequests[index] to access user data
                    // removing the mentee from the mentor's requests list
                    // changing the approved status of mentee from pending to false
                    FirebaseHelper()
                        .rejectRequest(mentorId, mentorshipRequests[index]!.id);
                    mentorshipRequests.removeAt(index);
                  });
                },
              ),
            ],
          ),
          focusColor: Colors.blue,
        );
      },
    );
  }

  Future<void> _fetchMentorshipRequests() async {
    List<String> userIds = await FirebaseHelper().getAllRequests(mentorId);
    List<Userr?> requests = [];
    for (String userId in userIds) {
      Userr? userData = await FirebaseHelper().getUserData(userId);
      requests.add(userData);
    }
    setState(() {
      mentorshipRequests = requests;
    });
  }
}

class CurrentMenteesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch current mentees
    // List<Mentee> currentMentees = fetchCurrentMentees();

    // For demonstration, using dummy data
    List<String> currentMentees = [
      'Mentee A',
      'Mentee B',
      'Mentee C',
    ];

    return ListView.builder(
      itemCount: currentMentees.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(currentMentees[index]),
          // Add additional information or actions for current mentees if needed
        );
      },
    );
  }
}
