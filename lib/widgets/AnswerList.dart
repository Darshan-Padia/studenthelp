import 'package:flutter/cupertino.dart';
import 'package:studenthelp/Models/StudentCommunityModels.dart';
import 'package:studenthelp/helper/firebase_helper.dart';

class AnswerList extends StatelessWidget {
  final Question question;
  final FirebaseHelper firebaseHelper;

  AnswerList({required this.question, required this.firebaseHelper});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Answer>>(
      stream: firebaseHelper.getAnswerStreamForQuestion(questionId: question.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CupertinoActivityIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Answer> answers = snapshot.data ?? [];
          return CupertinoPageScaffold(
            child: SafeArea(
              child: answers.isEmpty
                  ? Center(child: Text('No answers found'))
                  : CupertinoListSection(
                      topMargin: 0,
                      children: answers.map((answer) {
                        return CupertinoListTile(
                          title: Text(answer.body),
                          subtitle: FutureBuilder<String>(
                            future: firebaseHelper.getPseudonym(answer.userId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CupertinoActivityIndicator();
                              } else if (snapshot.hasError) {
                                return Text('By: Unknown');
                              } else {
                                return Text('By: ${snapshot.data}');
                              }
                            },
                          ),
                          // Add comment functionality here
                        );
                      }).toList(),
                    ),
            ),
          );
        }
      },
    );
  }
}