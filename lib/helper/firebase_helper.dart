import 'dart:developer';
import 'dart:math';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studenthelp/Models/Alumini.dart';
import 'package:studenthelp/Models/Mentor.dart';
import 'package:studenthelp/Models/ProjectModel.dart';
import 'package:studenthelp/Models/StudentCommunityModels.dart';
import 'package:studenthelp/Models/UserModel.dart';

class FirebaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userCollection = 'users';
  final String mentorCollection = 'mentors'; // New collection for mentors
  final String questionCollection = 'questions';
  final String answerCollection = 'answers';
  final String commentCollection = 'comments';
  final String projectCollection = 'projects';
  final String alumniCollection = 'alumni'; // New collection for alumni data

/////////////////////////////////////////////////////////////
// Add a new project to Firestore
  Future<String> addProject(
      {required String projectId,
      required String userId,
      required String title,
      required String description,
      required String techStack,
      required List<String> teamMembers,
      required String facultyGuide,
      String? driveLink,
      String? gitRepoLink,
      required semester}) async {
    try {
      DocumentReference docRef = await _firestore.collection('projects').add({
        'projectId': projectId,
        'userId': userId,
        'title': title,
        'description': description,
        'techStack': techStack,
        'teamMembers': teamMembers,
        'facultyGuide': facultyGuide,
        'driveLink': driveLink,
        'gitRepoLink': gitRepoLink,
        'timestamp': FieldValue.serverTimestamp(),
        'semester': semester, // Add semester field to the project document
      });

      return docRef.id;
    } catch (e) {
      print('Error adding project: $e');
      return '';
    }
  }

// Get all projects from Firestore
  Future<List<Project>> getAllProjects() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('projects').get();

      return querySnapshot.docs.map((doc) {
        return Project.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error getting all projects: $e');
      return [];
    }
  }

// Get projects by user ID
  Future<List<Project>> getProjectsByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('projects')
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) {
        return Project.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error getting projects by user ID: $e');
      return [];
    }
  }

  Future<void> updateProject({
    required String projectId,
    required String title,
    required String description,
    required String techStack,
    required List<String> teamMembers,
    required String facultyGuide,
    String? driveLink,
    String? gitRepoLink,
    required String semester,
  }) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('projects')
          .where('projectId', isEqualTo: projectId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update the document
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            'title': title,
            'description': description,
            'techStack': techStack,
            'teamMembers': teamMembers,
            'facultyGuide': facultyGuide,
            'driveLink': driveLink,
            'gitRepoLink': gitRepoLink,
            'semester': semester,
          });
        });
      } else {
        print('Document with projectId: $projectId does not exist.');
      }
    } catch (e) {
      print('Error updating project: $e');
    }
  }

// Delete a project from Firestore
  Future<void> deleteProject(String projectId) async {
    try {
      await _firestore.collection('projects').doc(projectId).delete();
    } catch (e) {
      print('Error deleting project: $e');
    }
  }
/////////////////////////////////////////////////////////////

  // Add a new mentor to Firestore
  Future<String> addMentor({
    required String userId,
    required String name,
  }) async {
    try {
      DocumentReference docRef =
          await _firestore.collection(mentorCollection).add({
        'name': name,
        'userId': userId,
        'mentees': [], // Initialize mentees as an empty list
        'requests': [], // Initialize requests as an empty list
      });

      return docRef.id;
    } catch (e) {
      print('Error adding mentor: $e');
      return '';
    }
  }

  // // get mentor list full
  // Future<List<Mentor>> getMentorList() async {
  //   try {
  //     QuerySnapshot querySnapshot =
  //         await _firestore.collection(mentorCollection).get();
  //     return querySnapshot.docs.map((doc) {
  //       return Mentor.fromMap(doc.data() as Map<String, dynamic>);
  //     }).toList();
  //   } catch (e) {
  //     print('Error getting mentor list: $e');
  //     return [];
  //   }
  // }
  Future<List<Mentor>> getMentorList() async {
    List<Mentor> mentorList = [];

    try {
      QuerySnapshot mentorSnapshot =
          await FirebaseFirestore.instance.collection(mentorCollection).get();

      mentorSnapshot.docs.forEach((doc) {
        Mentor mentor = Mentor.fromMap(doc.data() as Map<String, dynamic>);
        mentorList.add(mentor);
      });

      return mentorList;
    } catch (e) {
      print("Error getting mentor list: $e");
      return []; // Return empty list if error occurs
    }
  }

  // update mentor requests data in Firestore adding new mentee request into existing requests
  Future<void> updateMentorRequests(
    String mentorId,
    String menteeId,
  ) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(mentorCollection)
          .where('userId', isEqualTo: mentorId)
          .get();

      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document found (assuming mentorId is unique)
        DocumentSnapshot mentorDoc = querySnapshot.docs.first;
        print(mentorDoc.data() as Map<String, dynamic>);

        // Get the mentor data
        Mentor mentor =
            Mentor.fromMap(mentorDoc.data() as Map<String, dynamic>);

        // Update the requests array
        mentor.requests.add(menteeId);

        // Update the mentor document in Firestore
        await _firestore.collection(mentorCollection).doc(mentorDoc.id).update({
          'requests': mentor.requests,
        });

        print('Mentor requests updated successfully for mentorId: $mentorId');
      } else {
        print('Document with mentorId: $mentorId does not exist.');
      }
    } catch (e) {
      print(
          'Error updating mentor requests for mentorId: $mentorId. Error: $e');
    }
  }

  // get mentor requests
  Future<List<String>> getMentorRequests(String mentorId) async {
    print(mentorId);
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection(mentorCollection).doc(mentorId).get();
      return List<String>.from(docSnapshot.get('requests'));
    } catch (e) {
      print('Error getting mentor requests: $e');
      return [];
    }
  }

  Future<List<String>> getAllRequests(String mentorId) async {
    List<String> requests = [];

    // Assuming you have initialized Firestore and mentorCollection variable
    QuerySnapshot querySnapshot = await _firestore
        .collection(mentorCollection)
        .where('userId', isEqualTo: mentorId)
        .get();

    // Loop through each document returned by the query
    querySnapshot.docs.forEach((doc) {
      // Access the 'requests' field of the mentor document
      List<dynamic> mentorRequests = doc['requests'];

      // Add each request to the 'requests' list
      mentorRequests.forEach((request) {
        requests.add(request);
      });
    });

    return requests;
  }

  // update mentor mentees data in Firestore adding new mentee into existing mentees
  Future<void> updateMentorMentees({
    required String mentorId,
    required String menteeId,
  }) async {
    try {
      await _firestore.collection(mentorCollection).doc(mentorId).update({
        'mentees': FieldValue.arrayUnion([menteeId]),
      });
    } catch (e) {
      print('Error updating mentor mentees: $e');
    }
  }

  // function to update add mentee to mentor mentees list
  Future<void> addMenteeToMentor({
    required String mentorId,
    required String menteeId,
  }) async {
    try {
      await _firestore.collection(mentorCollection).doc(mentorId).update({
        'mentees': FieldValue.arrayUnion([menteeId]),
      });
    } catch (e) {
      print('Error updating mentor mentees: $e');
    }
  }

  // function to remove mentee from mentor request list
  Future<void> removeMenteeFromMentorRequests({
    required String mentorId,
    required String menteeId,
  }) async {
    try {
      await _firestore.collection(mentorCollection).doc(mentorId).update({
        'requests': FieldValue.arrayRemove([menteeId]),
      });
    } catch (e) {
      print('Error updating mentor requests: $e');
    }
  }

  // Add a new alumni to Firestore
  Future<String> addAlumni({
    required String firstName,
    required String lastName,
    required String companyName,
    required List<String> skills,
    required String headline,
    required String summary,
    required String profilePhotoUrl,
    required String email,
    required String phone,
  }) async {
    try {
      DocumentReference docRef =
          await _firestore.collection(alumniCollection).add({
        'firstName': firstName,
        'lastName': lastName,
        'companyName': companyName,
        'skills': skills,
        'headline': headline,
        'summary': summary,
        'profile_photo_url': profilePhotoUrl,
        'email': email,
        'phone': phone,
      });

      return docRef.id; // Return the auto-generated alumni ID
    } catch (e) {
      print('Error adding alumni: $e');
      return ''; // Return an empty string or handle the error accordingly
    }
  }

  // Update alumni data in Firestore
  Future<void> updateAlumni({
    required String alumniId,
    required String firstName,
    required String lastName,
    required String companyName,
    required List<String> skills,
    required String headline,
    required String summary,
    required String profilePhotoUrl,
    required String email,
    required String phone,
  }) async {
    try {
      await _firestore.collection(alumniCollection).doc(alumniId).update({
        'firstName': firstName,
        'lastName': lastName,
        'companyName': companyName,
        'skills': skills,
        'headline': headline,
        'summary': summary,
        'profile_photo_url': profilePhotoUrl,
        'email': email,
        'phone': phone,
      });
    } catch (e) {
      print('Error updating alumni: $e');
    }
  }

  // Search alumni by skills, name, or company name
  Future<List<Alumni>> searchAlumni({
    String? querySkills,
    String? queryName,
    String? queryCompanyName,
  }) async {
    try {
      Query alumniQuery = _firestore.collection(alumniCollection);

      if (querySkills != null && querySkills.isNotEmpty) {
        alumniQuery = alumniQuery.where('skills', arrayContains: querySkills);
      }

      if (queryName != null && queryName.isNotEmpty) {
        //  checking names after lowercasing both the names, database and query and spliting from space
        var firstNameee = queryName.toLowerCase().split(' ')[0];
        late var lastNameee;
        try {
          lastNameee = queryName.toLowerCase().split(' ')[1];
        } catch (e) {
          lastNameee = "";
        }

        // check if any of the name is empty
        if (firstNameee.isNotEmpty && lastNameee.isNotEmpty) {
          print(firstNameee);
          print(lastNameee);
          alumniQuery = alumniQuery
              .where('firstName', isEqualTo: firstNameee)
              .where('lastName', isEqualTo: lastNameee);
        } else if (firstNameee.isNotEmpty) {
          alumniQuery = alumniQuery.where('firstName', isEqualTo: firstNameee);
          //print("any");
          //getAllAlumniNames();
        } else if (lastNameee.isNotEmpty) {
          alumniQuery = alumniQuery.where('lastName', isEqualTo: lastNameee);
        }
        // .where('lastName', isEqualTo: queryName);
        print(queryName);
      }

      if (queryCompanyName != null && queryCompanyName.isNotEmpty) {
        alumniQuery =
            alumniQuery.where('companyName', isEqualTo: queryCompanyName);
      }

      QuerySnapshot querySnapshot = await alumniQuery.get();
      print(querySnapshot.docs.length);
      var data = querySnapshot.docs
          .where((doc) {
            print(doc.data());
            // log('doc.data() ${doc.data()}', name: 'searchAlumni');
            return doc.data() != null;
          })
          .map((doc) => Alumni.fromMap(doc.data()! as Map<String, dynamic>))
          .toList();
      print(data);
      return data;
    } catch (e) {
      print('Error searching alumni: $e');
      return [];
    }
  }

  Future<List<Alumni>> getAllAlumni() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(alumniCollection).get();
      return querySnapshot.docs
          .where((doc) => doc.data() != null) // Filter out null data
          .map((doc) => Alumni.fromMap(doc.data()! as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting alumni: $e');
      return []; // Return an empty list or handle the error accordingly
    }
  }

// Get all names of alumni from Firestore
  Future<List<String>> getAllAlumniNames() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(alumniCollection).get();
      var data = querySnapshot.docs
          .where((doc) => doc.data() != null)
          .map((doc) =>
              '${(doc.data() as Map<String, dynamic>)['firstName']} ${(doc.data() as Map<String, dynamic>)['lastName']}')
          .toList();
      print(data);
      return data;
    } catch (e) {
      print('Error getting all alumni names: $e');
      return [];
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

  Future<String> generatePseudonym(String name) async {
    // Define characters that can be used in pseudonym
    const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';

    // Generate a random pseudonym
    String pseudonym = '';
    final random = Random.secure();
    for (int i = 0; i < 8; i++) {
      pseudonym += characters[random.nextInt(characters.length)];
    }

    // Check if the pseudonym already exists
    bool isUnique = false;
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

// Generate a unique and meaningful pseudonym for a new user
  // Future<String> generatePseudonym(String name) async {
  //   // Extract initials from the user's name
  //   List<String> nameParts = name.split(' ');
  //   String initials = '';
  //   nameParts.forEach((part) {
  //     if (part.isNotEmpty) {
  //       initials += part[0].toUpperCase();
  //     }
  //   });

  //   // Check if the pseudonym already exists
  //   bool isUnique = false;
  //   String pseudonym = initials;
  //   int suffix = 1;
  //   while (!isUnique) {
  //     String checkPseudonym = pseudonym;
  //     if (suffix > 1) {
  //       checkPseudonym += suffix.toString();
  //     }
  //     QuerySnapshot querySnapshot = await _firestore
  //         .collection(userCollection)
  //         .where('pseudonym', isEqualTo: checkPseudonym)
  //         .get();

  //     if (querySnapshot.docs.isEmpty) {
  //       isUnique = true;
  //       pseudonym = checkPseudonym;
  //     } else {
  //       suffix++;
  //     }
  //   }

  //   return pseudonym;
  // }

// Add a new user to Firestore
  Future<String> addUser({
    required String name,
    required String email,
    required String phoneNumber,
    required String organization,
    required String profession,
    required List<String> skills,
    required String city,
    String? mentorId, // Default value: null
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
        'mentorId': mentorId ?? "", // Default value: null
        'approved': 'false', // Default value: 'false' as string
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

  Future<void> updateUserApprovedStatus(String uid, String approved) async {
    try {
      await _firestore
          .collection(userCollection)
          .where('userId', isEqualTo: uid)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({'approved': approved});
        });
      });
    } catch (e) {
      print('Error updating user approved status: $e');
    }
  }

  // combine accept request function
  Future<void> acceptRequest(String mentorId, String menteeId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(mentorCollection)
          .where('userId', isEqualTo: mentorId)
          .get();
      // Update the mentor's mentees list
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({
          'mentees': FieldValue.arrayUnion([menteeId]),
        });
      });

      // Remove the mentee from the mentor's requests list
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({
          'requests': FieldValue.arrayRemove([menteeId]),
        });
      });

      // Update the mentee's approved status to true
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({'approved': 'true'});
      });
    } catch (e) {
      print('Error accepting mentorship request: $e');
    }
  }

  // combine reject request function
  Future<void> rejectRequest(String mentorId, String menteeId) async {
    try {
      // Remove the mentee from the mentor's requests list
      await _firestore.collection(mentorCollection).doc(mentorId).update({
        'requests': FieldValue.arrayRemove([menteeId]),
      });

      // Update the mentee's approved status to false
      await updateUserApprovedStatus(menteeId, 'false');
    } catch (e) {
      print('Error rejecting mentorship request: $e');
    }
  }

  // Approve mentee request by mentor
  Future<void> approveMenteeRequest(String menteeId) async {
    try {
      await _firestore
          .collection(userCollection)
          .where('userId', isEqualTo: menteeId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({'approved': true});
        });
      });
    } catch (e) {
      print('Error approving mentee request: $e');
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
