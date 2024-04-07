import 'package:flutter/cupertino.dart';

void main() {
  runApp(IphoneScreen());
}

class IphoneScreen extends StatefulWidget {
  @override
  _IphoneScreenState createState() => _IphoneScreenState();
}

class _IphoneScreenState extends State<IphoneScreen> {
  List<String> items = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape',
    'Honeydew',
    'Kiwi',
    'Lemon',
  ];

  List<String> pickedItems = [];
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Picker Example'),
        ),
        child: SafeArea(
          child: Column(
            children: [
              CupertinoSearchTextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                placeholder: 'Search',
              ),
              SizedBox(height: 10),
              CupertinoButton.filled(
                child: Text('Pick Item'),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      title: Text('Select an Item'),
                      message: Text('Choose from the list'),
                      actions: items
                          .where((item) => item
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()))
                          .map((item) => CupertinoActionSheetAction(
                                child: Text(item),
                                onPressed: () {
                                  setState(() {
                                    pickedItems.add(item);
                                  });
                                  Navigator.pop(context);
                                },
                              ))
                          .toList(),
                      cancelButton: CupertinoActionSheetAction(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              Expanded(
                child: pickedItems.isNotEmpty
                    ? CupertinoListSection(
                        topMargin: 0,
                        children: pickedItems
                            .map((item) => CupertinoListTile(title: Text(item)))
                            .toList(),
                      )
                    : CupertinoListSection(
                        topMargin: 0,
                        header: Text('No items picked yet'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
