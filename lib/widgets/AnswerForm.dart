import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:studenthelp/Models/StudentCommunityModels.dart';
import 'package:studenthelp/helper/firebase_helper.dart';
import 'package:get/get.dart';

class AddAnswerForm extends StatelessWidget {
  final Question question;
  final FirebaseHelper firebaseHelper;
  final TextEditingController _answerController = TextEditingController();

  AddAnswerForm({required this.question, required this.firebaseHelper});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Text(
          //   'Your Answer',
          //   style: Theme.of(context).textTheme.subtitle1,
          // ),
          // SizedBox(height: 8.0),
          // TextField(
          //   decoration: InputDecoration(
          //     hintText: 'Write your answer here...',
          //     border: OutlineInputBorder(),
          //   ),
          //   controller: _answerController,
          //   minLines: 3,
          //   maxLines: 5,
          // ),
          // SizedBox(height: 16.0),
          // ElevatedButton(
          //   onPressed: () {
          //     _submitAnswer(context);
          //   },
          //   child: Text('Submit Answer'),
          // ),
          Text(
            'Your Answer',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          CupertinoTextField(
            controller: _answerController,
            placeholder: 'Write your answer here...',
            minLines: 3,
            maxLines: 5,
            decoration: BoxDecoration(
              border: Border.all(color: CupertinoColors.systemGrey),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          SizedBox(height: 16.0),
          CupertinoButton(
            onPressed: () {
              _submitAnswer(context);
            },
            color: CupertinoColors.activeBlue,
            child: Text('Submit Answer'),
          ),
        ],
      ),
    );
  }

  void _submitAnswer(BuildContext context) {
    final String answerBody = _answerController.text.trim();
    if (answerBody.isNotEmpty) {
      firebaseHelper.addAnswer(
        body: answerBody,
        userId: FirebaseAuth.instance.currentUser!.uid,
        questionId: question.id,
      );
      _answerController.clear(); // Clear text field after submission
      // get snackbar
      Get.snackbar('Answer Submitted', 'Your answer has been submitted');
    } else {
      Get.snackbar('Error', 'Please write your answer');
    }
  }
}
