import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:studenthelp/Models/StudentCommunityModels.dart';
import 'package:studenthelp/components/QuestionDetailPage.dart';
import 'package:studenthelp/helper/firebase_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studenthelp/settings/theme_provider.dart';

class StudentCommunityForumPage extends StatefulWidget {
  const StudentCommunityForumPage({Key? key}) : super(key: key);

  @override
  State<StudentCommunityForumPage> createState() =>
      _StudentCommunityForumPageState();
}

class _StudentCommunityForumPageState extends State<StudentCommunityForumPage> {
  final FirebaseHelper _firebaseHelper = FirebaseHelper();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeStateProvider>(builder: (context, theme, child) {
      return SafeArea(
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('Student Community Forum'),
          ),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<Question>>(
                  stream: _firebaseHelper.getQuestionStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CupertinoActivityIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Error: ${snapshot.error.toString()}'));
                    } else {
                      List<Question> questions = snapshot.data ?? [];
                      return QuestionList(questions: questions);
                    }
                  },
                ),
              ),
              CupertinoButton(
                onPressed: () {
                  _showAddQuestionDialog(context);
                },
                child: Icon(CupertinoIcons.add),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showAddQuestionDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController bodyController = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Add Question'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoTextField(
              controller: titleController,
              placeholder: 'Title',
            ),
            SizedBox(height: 8),
            CupertinoTextField(
              controller: bodyController,
              placeholder: 'Body',
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              String userId = FirebaseAuth.instance.currentUser!.uid;
              String title = titleController.text;
              String body = bodyController.text;

              if (title.isNotEmpty && body.isNotEmpty) {
                // Add question using FirebaseHelper
                await _firebaseHelper.addQuestion(
                  title: title,
                  body: body,
                  userId: userId,
                );

                // Close dialog and show success message
                Get.back();
                Get.snackbar('Success', 'Question added successfully');
              } else {
                Get.snackbar('Error', 'Please fill all fields');
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}

class QuestionList extends StatefulWidget {
  final List<Question> questions;

  QuestionList({required this.questions});

  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  late List<Question> filteredQuestions;

  @override
  void initState() {
    filteredQuestions = widget.questions;
    super.initState();
  }

  void filterQuestions(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredQuestions = widget.questions;
      });
    } else {
      setState(() {
        filteredQuestions = widget.questions
            .where((question) =>
                question.title.toLowerCase().contains(query.toLowerCase()) ||
                question.body.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeStateProvider>(builder: (context, theme, child) {
      Color dividerColor = theme.isDarkTheme
          ? Colors.white.withOpacity(0.4)
          : Colors.black.withOpacity(0.4);

      return Flexible(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: CupertinoSearchTextField(
                  onChanged: filterQuestions,
                  placeholder: 'Search',
                ),
              ),
              Expanded(
                child: filteredQuestions.isEmpty
                    ? Center(
                        child: Text('No questions found.'),
                      )
                    : SingleChildScrollView(
                        child: CupertinoListSection(
                          topMargin: 0,
                          children: filteredQuestions
                              .map((question) => CupertinoListTile(
                                    leadingSize: 60, // I
                                    title: Text(question.title),
                                    subtitle: Text(question.body),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              QuestionDetailPage(
                                            question: question,
                                          ),
                                        ),
                                      );
                                    },
                                  ))
                              .toList(),
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
