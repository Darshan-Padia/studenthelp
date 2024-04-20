// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:studenthelp/Models/StudentCommunityModels.dart';
// import 'package:studenthelp/helper/firebase_helper.dart';
// import 'package:studenthelp/settings/theme_provider.dart';
// import 'package:studenthelp/widgets/AnswerForm.dart';
// import 'package:studenthelp/widgets/AnswerList.dart';
// import 'package:get/get.dart';

// class QuestionDetailPage extends StatelessWidget {
//   final Question question;
//   final FirebaseHelper _firebaseHelper = FirebaseHelper();

//   QuestionDetailPage({required this.question});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeStateProvider>(builder: (context, theme, child) {
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: theme.isDarkTheme
//               ? const Color.fromARGB(255, 6, 5, 5)
//               : Colors.blue,
//           title: Text(question.title),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.share),
//               onPressed: () {
//                 // Implement share functionality
//               },
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color:
//                       theme.isDarkTheme ? Colors.grey[900] : Colors.blue[100],
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Text(
//                   question.body,
//                   style: TextStyle(fontSize: 16.0),
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Text(
//                   'Answers',
//                   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               AnswerList(question: question, firebaseHelper: _firebaseHelper),
//               SizedBox(height: 16.0),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: AddAnswerForm(
//                     question: question, firebaseHelper: _firebaseHelper),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
