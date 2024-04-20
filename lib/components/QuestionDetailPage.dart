import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:studenthelp/Models/StudentCommunityModels.dart';
import 'package:studenthelp/helper/firebase_helper.dart';
import 'package:studenthelp/settings/theme_provider.dart';
import 'package:studenthelp/widgets/AnswerForm.dart';
import 'package:studenthelp/widgets/AnswerList.dart';
import 'package:get/get.dart';


class QuestionDetailPage extends StatelessWidget {
  final Question question;
  final FirebaseHelper _firebaseHelper = FirebaseHelper();

  QuestionDetailPage({required this.question});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeStateProvider>(builder: (context, theme, child) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(question.title),
          trailing: 
          CupertinoButton(
            child: Icon(CupertinoIcons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: theme.isDarkTheme ? CupertinoColors.systemGrey2 : CupertinoColors.systemBlue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    question.body,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Answers',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16.0),
                AnswerList(question: question, firebaseHelper: _firebaseHelper),
                SizedBox(height: 16.0),
                AddAnswerForm(question: question, firebaseHelper: _firebaseHelper),
              ],
            ),
          ),
        ),
      );
    });

  }
}