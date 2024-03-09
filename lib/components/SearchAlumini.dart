import 'package:flutter/material.dart';
import 'package:studenthelp/Models/Alumini.dart';
import 'package:studenthelp/helper/firebase_helper.dart'; // Import your FirebaseHelper

class SearchAlumniPage extends StatefulWidget {
  @override
  _SearchAlumniPageState createState() => _SearchAlumniPageState();
}

class _SearchAlumniPageState extends State<SearchAlumniPage> {
  TextEditingController _searchController = TextEditingController();
  List<Alumni> _searchResults = [];
  String _searchType = 'Name'; // Default search type

  void _searchAlumni() async {
    String query = _searchController.text.trim();
    List<Alumni> results = [];

    if (_searchType == 'Name') {
      results = await FirebaseHelper().searchAlumni(
        queryName: query,
      );
    } else if (_searchType == 'Skills') {
      results = await FirebaseHelper().searchAlumni(
        querySkills: query,
      );
    } else if (_searchType == 'Company Name') {
      results = await FirebaseHelper().searchAlumni(
        queryCompanyName: query,
      );
    }

    setState(() {
      _searchResults = results;
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
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: _searchAlumni,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                Alumni alumni = _searchResults[index];
                return ListTile(
                  title: Text('${alumni.firstName} ${alumni.lastName}'),
                  subtitle: Text(alumni.companyName),
                  onTap: () {
                    // Navigate to alumni profile screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlumniProfilePage(alumni: alumni),
                      ),
                    );
                  },
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
