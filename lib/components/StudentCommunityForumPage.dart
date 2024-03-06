import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:studenthelp/Models/StudentCommunityModels.dart';
import 'package:studenthelp/components/QuestionDetailPage.dart';
import 'package:studenthelp/helper/firebase_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studenthelp/settings/theme_provider.dart';

class StudentCommunityForumPage extends StatelessWidget {
  final FirebaseHelper _firebaseHelper = FirebaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Community Forum'),
      ),
      body: StreamBuilder<List<Question>>(
        stream: _firebaseHelper.getQuestionStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Question> questions = snapshot.data ?? [];
            return QuestionList(questions: questions);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddQuestionDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddQuestionDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Question'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(labelText: 'Body'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
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
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Question added successfully')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill all fields')),
                );
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}

class QuestionList extends StatelessWidget {
  final List<Question> questions;

  QuestionList({required this.questions});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeStateProvider>(builder: (context, theme, child) {
      Color dividerColor = theme.isDarkTheme
          ? Colors.white.withOpacity(0.4)
          : Colors.black.withOpacity(0.4);

      return ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(questions[index].title),
                subtitle: Text(questions[index].body),
                onTap: () {
                  Get.to(() => QuestionDetailPage(question: questions[index]));
                },
              ),
              Divider(
                color: dividerColor,
                thickness: 1.0,
              ),
            ],
          );
        },
      );
    });
  }
}
