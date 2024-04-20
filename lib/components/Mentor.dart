import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
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
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_3),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2),
            label: 'Current Mentees',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('Mentor Dashboard'),
          ),
          child: _buildBody(index),
        );
      },
    );
  }

  Widget _buildBody(int index) {
    switch (index) {
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

/*
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
 */

class RequestsScreen extends StatefulWidget {
  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  List<Userr?> mentorshipRequests = [];
  String mentorId = FirebaseAuth.instance.currentUser!.uid;
  bool _isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    _fetchMentorshipRequests();
  }



  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: _isLoading
            ? Center(
                child:
                    CupertinoActivityIndicator()) // Show loader while loading
            : mentorshipRequests.isEmpty
                ? Center(
                    child: Text(
                        'No mentee requests found')) // Show message if no requests
                : CupertinoListSection(
                    topMargin: 0,
                    children: mentorshipRequests.map((request) {
                      return CupertinoListTile(
                        title: Text(request!.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CupertinoButton(
                              child: Icon(
                                CupertinoIcons.check_mark_circled,
                                color: CupertinoColors.systemGreen,
                              ),
                              onPressed: () {
                                setState(() {
                               
                                  FirebaseHelper()
                                      .acceptRequest(mentorId, request.id);
                                  // mentorshipRequests.remove(request);
                                });
                              },
                            ),
                            CupertinoButton(
                              child: Icon(
                                CupertinoIcons.clear_circled,
                                color: CupertinoColors.systemRed,
                              ),
                              onPressed: () {
                                setState(() {
         
                                  FirebaseHelper()
                                      .rejectRequest(mentorId, request.id);
                                  mentorshipRequests.remove(request);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
      ),
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
    _isLoading = false; // Set loading to false after data is fetched
  });
}
}
class CurrentMenteesScreen extends StatefulWidget {
  @override
  _CurrentMenteesScreenState createState() => _CurrentMenteesScreenState();
}

class _CurrentMenteesScreenState extends State<CurrentMenteesScreen> {
  List<Userr?> mentees = [];
  String mentorId = FirebaseAuth.instance.currentUser!.uid;
  bool _isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    _fetchMentees();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: _isLoading
            ? Center(
                child:
                    CupertinoActivityIndicator()) // Show loader while loading
            : mentees.isEmpty
                ? Center(
                    child: Text(
                        'No mentees found')) // Show message if no mentees
                : CupertinoListSection(
                    topMargin: 0,
                    children: mentees.map((mentee) {
                      return CupertinoListTile(
                        title: Text(mentee!.name),
                        trailing: CupertinoButton(
                          child: Text('View Profile'),
                          onPressed: () {
                            // Navigate to mentee's profile
                          },
                        ),
                      );
                    }).toList(),
                  ),
      ),
    );
  }

  Future<void> _fetchMentees() async {
  List<String> userIds = await FirebaseHelper().getCurrentMentees(mentorId);
  List<Userr?> menteeList = [];
  for (String userId in userIds) {
    Userr? userData = await FirebaseHelper().getUserData(userId);
    menteeList.add(userData);
  }
  setState(() {
    mentees = menteeList;
    _isLoading = false; // Set loading to false after data is fetched
  });
}
}