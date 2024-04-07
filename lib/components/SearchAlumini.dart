import 'package:flutter/cupertino.dart';
import 'package:studenthelp/Models/Alumini.dart';
import 'package:studenthelp/helper/firebase_helper.dart'; // Import your FirebaseHelper

class SearchAlumniPage extends StatefulWidget {
  const SearchAlumniPage({super.key});

  @override
  State<SearchAlumniPage> createState() => _SearchAlumniPageState();
}

class _SearchAlumniPageState extends State<SearchAlumniPage> {
  TextEditingController _searchController = TextEditingController();
  List<Alumni> _allAlumni = [];
  List<Alumni> _searchResults = [];
  String _searchType = 'Name'; // Default search type
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    _fetchAllAlumniDetails(); // Fetch all alumni details when the widget initializes
  }

  void _fetchAllAlumniDetails() async {
    try {
      // Fetch all alumni details from the database
      List<Alumni> allAlumni = await FirebaseHelper().getAllAlumni();
      setState(() {
        _allAlumni = allAlumni;
      });
    } catch (e) {
      print('Error fetching alumni: $e');
      // Handle error appropriately
    }
  }

  void _searchAlumni() {
    setState(() {
      _isSearching = true;
    });

    String query = _searchController.text.trim().toLowerCase();
    List<Alumni> results = [];

    if (_searchType == 'Name') {
      results = _allAlumni
          .where((alumni) =>
              alumni.firstName.toLowerCase().contains(query) ||
              alumni.lastName.toLowerCase().contains(query))
          .toList();
    } else if (_searchType == 'Skills') {
      results = _allAlumni
          .where((alumni) =>
              alumni.skills.any((skill) => skill.toLowerCase().contains(query)))
          .toList();
    } else if (_searchType == 'Company Name') {
      results = _allAlumni
          .where((alumni) => alumni.companyName.toLowerCase().contains(query))
          .toList();
    }

    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('Search Alumni'),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SafeArea(
              child: Column(
                children: [
                  CupertinoSearchTextField(
                    controller: _searchController,
                    onSubmitted: (_) => _searchAlumni(),
                  ),
                  SizedBox(height: 20.0),
                  CupertinoSegmentedControl(
                    children: {
                      'Name': Text('Name'),
                      'Skills': Text('Skills'),
                      'Company Name': Text('Company Name'),
                    },
                    groupValue: _searchType,
                    onValueChanged: (value) {
                      setState(() {
                        _searchType = value.toString();
                      });
                    },
                  ),
                  if (_isSearching)
                    CupertinoActivityIndicator()
                  else
                    Expanded(
                      child: _searchResults
                              .isNotEmpty // Check if search results are not empty
                          ? CupertinoListSection(
                              children: _searchResults
                                  .map((alumni) => CupertinoListTile(
                                        title: Text(
                                            '${alumni.firstName} ${alumni.lastName}'),
                                        subtitle: Text(alumni.companyName),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  AlumniProfilePage(
                                                alumni: alumni,
                                              ),
                                            ),
                                          );
                                        },
                                      ))
                                  .toList(),
                            )
                          : Center(
                              child: Text(
                                  'No results found'), // Display a message when there are no search results
                            ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AlumniProfilePage extends StatelessWidget {
  final Alumni alumni;

  const AlumniProfilePage({required this.alumni});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Alumni Profile'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${alumni.firstName} ${alumni.lastName}'),
            Text(alumni.companyName),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
