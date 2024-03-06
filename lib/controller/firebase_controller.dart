import 'package:get/get.dart';
import 'package:studenthelp/Models/StudentCommunityModels.dart';

class FirebaseHelper extends GetxController {
  // Your existing FirebaseHelper implementation

  // Example method:
  // Observable list of answers
  RxList<Answer> answers = <Answer>[].obs;

  // Example method to add an answer
  void addAnswer(Answer answer) {
    answers.add(answer);
  }
}
