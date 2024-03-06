import 'package:flutter/material.dart';
import 'package:studenthelp/Models/StudentCommunityModels.dart';
import 'package:studenthelp/helper/firebase_helper.dart';
import 'package:get/get.dart';

class AnswerList extends StatelessWidget {
  final Question question;
  final FirebaseHelper firebaseHelper;

  AnswerList({required this.question, required this.firebaseHelper});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Answer>>(
      stream:
          firebaseHelper.getAnswerStreamForQuestion(questionId: question.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Answer> answers = snapshot.data ?? [];
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: answers.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                          answers[index].body,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        subtitle: FutureBuilder<String>(
                          future: firebaseHelper
                              .getPseudonym(answers[index].userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('By: Unknown');
                            } else {
                              return Text('By: ${snapshot.data}');
                            }
                          },
                        ),
                        // Add comment functionality here
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
