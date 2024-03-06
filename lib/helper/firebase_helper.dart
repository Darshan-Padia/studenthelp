import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studenthelp/Models/Alumini.dart';
import 'package:studenthelp/Models/StudentCommunityModels.dart';
import 'package:studenthelp/Models/UserModel.dart';

class FirebaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userCollection = 'users';
  final String questionCollection = 'questions';
  final String answerCollection = 'answers';
  final String commentCollection = 'comments';
  final String alumniCollection = 'alumni'; // New collection for alumni data
  // Add a new alumni to Firestore
  Future<String> addAlumni(
      {required String firstName,
      required String lastName,
      required String companyName,
      required List<String> skills,
      required String headline,
      required String summary,
      required String profile_photo_url}) async {
    try {
      DocumentReference docRef =
          await _firestore.collection(alumniCollection).add({
        'firstName': firstName,
        'lastName': lastName,
        'companyName': companyName,
        'skills': skills,
        'headline': headline,
        'summary': summary,
        'profile_photo_url': profile_photo_url
      });

      return docRef.id; // Return the auto-generated alumni ID
    } catch (e) {
      print('Error adding alumni: $e');
      return ''; // Return an empty string or handle the error accordingly
    }
  }

  // Get alumni data from Firestore
  Future<List<Alumni>> getAlumni() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(alumniCollection).get();
      return querySnapshot.docs
          .where((doc) => doc.data() != null) // Filter out null data
          .map((doc) => Alumni.fromMap(doc.data()! as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting alumni: $e');
      return [];
    }
  }

  // Add a new question to Firestore
  Future<String> addQuestion({
    required String title,
    required String body,
    required String userId, // ID of the user who posted the question
  }) async {
    try {
      DocumentReference docRef = _firestore
          .collection(questionCollection)
          .doc(); // Create a reference without an ID

      await docRef.set({
        'id': docRef.id, // Assign the auto-generated ID to the document
        'title': title,
        'body': body,
        'userId': userId,
        'timestamp':
            DateTime.now(), // Timestamp of when the question was posted
      });

      return docRef.id; // Return the auto-generated question ID
    } catch (e) {
      print('Error adding question: $e');
      return ''; // Return an empty string or handle the error accordingly
    }
  }

// Add a new answer to Firestore
  Future<String> addAnswer({
    required String body,
    required String userId, // ID of the user who posted the answer
    required String questionId, // ID of the question being answered
  }) async {
    try {
      DocumentReference docRef = _firestore
          .collection(answerCollection)
          .doc(); // Create a reference without an ID

      await docRef.set({
        'id': docRef.id, // Assign the auto-generated ID to the document
        'body': body,
        'userId': userId,
        'questionId': questionId,
        'timestamp': DateTime.now(), // Timestamp of when the answer was posted
      });

      return docRef.id; // Return the auto-generated answer ID
    } catch (e) {
      print('Error adding answer: $e');
      return ''; // Return an empty string or handle the error accordingly
    }
  }

  // Get questions from Firestore
  // Get questions from Firestore as a stream
  Stream<List<Question>> getQuestionStream() {
    try {
      return _firestore.collection(questionCollection).snapshots().map(
          (querySnapshot) => querySnapshot.docs
              .where((doc) => doc.data() != null) // Filter out null data
              .map((doc) =>
                  Question.fromMap(doc.data()! as Map<String, dynamic>))
              .toList());
    } catch (e) {
      print('Error getting question stream: $e');
      return Stream.value([]); // Return an empty stream in case of error
    }
  }

  // Get questions from Firestore
  Future<List<Question>> getQuestions() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(questionCollection).get();
      return querySnapshot.docs
          .where((doc) => doc.data() != null) // Filter out null data
          .map((doc) => Question.fromMap(doc.data()! as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting questions: $e');
      return [];
    }
  }

  // Get answers for a specific question from Firestore as a stream
  Stream<List<Answer>> getAnswerStreamForQuestion(
      {required String questionId}) {
    try {
      return _firestore
          .collection(answerCollection)
          .where('questionId', isEqualTo: questionId)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
              .where((doc) => doc.data() != null) // Filter out null data
              .map((doc) => Answer.fromMap(doc.data()! as Map<String, dynamic>))
              .toList());
    } catch (e) {
      print('Error getting answer stream for question: $e');
      return Stream.value([]); // Return an empty stream in case of error
    }
  }

  // Get answers for a specific question from Firestore
  Future<List<Answer>> getAnswersForQuestion(
      {required String questionId}) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(answerCollection)
          .where('questionId', isEqualTo: questionId)
          .get();
      return querySnapshot.docs
          .where((doc) => doc.data() != null) // Filter out null data
          .map((doc) => Answer.fromMap(doc.data()! as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting answers for question: $e');
      return [];
    }
  }

  // Add a new comment to Firestore
  Future<String> addComment({
    required String body,
    required String userId, // ID of the user who posted the comment
    required String answerId, // ID of the answer being commented on
  }) async {
    try {
      DocumentReference docRef =
          await _firestore.collection(commentCollection).add({
        'body': body,
        'userId': userId,
        'answerId': answerId,
        'timestamp': DateTime.now(), // Timestamp of when the comment was posted
      });

      return docRef.id; // Return the auto-generated comment ID
    } catch (e) {
      print('Error adding comment: $e');
      return ''; // Return an empty string or handle the error accordingly
    }
  }

// Generate a unique and meaningful pseudonym for a new user
  Future<String> generatePseudonym(String name) async {
    // Extract initials from the user's name
    List<String> nameParts = name.split(' ');
    String initials = '';
    nameParts.forEach((part) {
      if (part.isNotEmpty) {
        initials += part[0].toUpperCase();
      }
    });

    // Check if the pseudonym already exists
    bool isUnique = false;
    String pseudonym = initials;
    int suffix = 1;
    while (!isUnique) {
      String checkPseudonym = pseudonym;
      if (suffix > 1) {
        checkPseudonym += suffix.toString();
      }
      QuerySnapshot querySnapshot = await _firestore
          .collection(userCollection)
          .where('pseudonym', isEqualTo: checkPseudonym)
          .get();

      if (querySnapshot.docs.isEmpty) {
        isUnique = true;
        pseudonym = checkPseudonym;
      } else {
        suffix++;
      }
    }

    return pseudonym;
  }

  // Add a new user to Firestore
  Future<String> addUser({
    required String name,
    required String email,
    required String phoneNumber,
    required String organization,
    required String profession,
    required List<String> skills,
    required String city,
  }) async {
    try {
      DocumentReference docRef =
          await _firestore.collection(userCollection).add({
        'userId': '', // Placeholder for the user ID
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'organization': organization,
        'profession': profession,
        'skills': skills,
        'city': city,
        'pseudonym': await generatePseudonym(name), // Generate a pseudonym
      });

      // Update the user document with the auto-generated user ID
      await docRef.update({'userId': FirebaseAuth.instance.currentUser!.uid});

      return docRef.id; // Return the auto-generated user ID
    } catch (e) {
      print('Error adding user: $e');
      return ''; // Return an empty string or handle the error accordingly
    }
  }

  // get all data of user from userId
  // Get user data from Firestore
  Future<Userr?> getUserData(String userId) async {
    try {
      // final DocumentSnapshot snapshot =
      //     await _firestore.collection(userCollection).doc(userId).get();
      QuerySnapshot querySnapshot = await _firestore
          .collection(userCollection)
          .where('userId', isEqualTo: userId)
          .get();
      DocumentSnapshot snapshot = querySnapshot.docs.first;

      if (snapshot.exists) {
        return Userr.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // get pseudonym from userid directly return string
  Future<String> getPseudonym(String userId) async {
    try {
      // DocumentSnapshot snapshot =
      //     await _firestore.collection(userCollection).doc(userId).get();
      QuerySnapshot querySnapshot = await _firestore
          .collection(userCollection)
          .where('userId', isEqualTo: userId)
          .get();
      DocumentSnapshot snapshot = querySnapshot.docs.first;

      if (snapshot.exists) {
        return snapshot.get('pseudonym');
      } else {
        print('User not found');
        return '';
      }
    } catch (e) {
      print('Error getting pseudonym: $e');
      return '';
    }
  }

  // Update user data in Firestore
  Future<void> updateUser({
    required String userId,
    required String name,
    required String email,
    required String phoneNumber,
    required String organization,
    required String profession,
    required List<String> skills,
    required String city,
  }) async {
    try {
      await _firestore.collection(userCollection).doc(userId).update({
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'organization': organization,
        'profession': profession,
        'skills': skills,
        'city': city,
      });
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  // Get user data from Firestore
  Future<Object?> getUser(String userId) async {
    try {
      final DocumentSnapshot snapshot =
          await _firestore.collection(userCollection).doc(userId).get();
      if (snapshot.exists) {
        return snapshot.data();
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Delete user from Firestore
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(userCollection).doc(userId).delete();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}
