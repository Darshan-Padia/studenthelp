import 'package:flutter/material.dart';
import 'package:studenthelp/Models/Alumini.dart';
import 'package:studenthelp/helper/firebase_helper.dart'; // Import your FirebaseHelper

class SearchAlumniPage extends StatefulWidget {
  @override
  _SearchAlumniPageState createState() => _SearchAlumniPageState();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Alumni'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text('Search By: '),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _searchType,
                    onChanged: (newValue) {
                      setState(() {
                        _searchType = newValue!;
                      });
                    },
                    items: <String>['Name', 'Skills', 'Company Name']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            if (value == 'Name') Icon(Icons.person),
                            if (value == 'Skills') Icon(Icons.work),
                            if (value == 'Company Name') Icon(Icons.business),
                            SizedBox(width: 8),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchAlumni,
                ),
              ],
            ),
          ),
          _isSearching
              ? CircularProgressIndicator() // Show loading indicator while searching
              : Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      Alumni alumni = _searchResults[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text('${alumni.firstName} ${alumni.lastName}'),
                          subtitle: Text(alumni.companyName),
                          onTap: () {
                            // Navigate to alumni profile screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AlumniProfilePage(alumni: alumni),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class AlumniProfilePage extends StatelessWidget {
  final Alumni alumni;

  const AlumniProfilePage({required this.alumni});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alumni Profile'),
      ),
      body: Center(
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
