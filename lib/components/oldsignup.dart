// signup.dart

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:studenthelp/components/login.dart';
// import 'package:studenthelp/helper/firebase_helper.dart';
// import 'package:studenthelp/home_screen.dart';
// import 'package:studenthelp/settings/theme_provider.dart';
// import 'package:studenthelp/widgets/text_field.dart';

// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final FirebaseHelper _firebaseHelper = FirebaseHelper();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _organizationNameController =
//       TextEditingController();
//   final TextEditingController _professionController = TextEditingController();
//   final TextEditingController _skillsController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Consumer<ThemeStateProvider>(builder: (context, theme, child) {
//       return Scaffold(
//         body: SingleChildScrollView(
//           child: Form(
//             child: Column(
//               children: [
//                 Container(
//                   height: size.height * 0.24,
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Theme.of(context).primaryColor,
//                         Theme.of(context).primaryColorDark,
//                         Theme.of(context).primaryColorLight,
//                       ],
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'StudentHelp',
//                         style: Theme.of(context).textTheme.headline2?.copyWith(
//                               color: Theme.of(context).hintColor,
//                               fontWeight: FontWeight.bold,
//                             ),
//                       ),
//                       const SizedBox(
//                         height: 6,
//                       ),
//                       Text(
//                         'Signup',
//                         style: Theme.of(context).textTheme.headline3?.copyWith(
//                               color: Colors.white,
//                             ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'Welcome to Student Help',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 20),
//                 CustomTextFieldBuilder(
//                   label: "name",
//                   controller: _nameController,
//                 ),
//                 CustomTextFieldBuilder(
//                   label: "Email",
//                   controller: _emailController,
//                 ),
//                 CustomTextFieldBuilder(
//                   label: "Password",
//                   controller: _passwordController,
//                   isPassword: true,
//                 ),
//                 CustomTextFieldBuilder(
//                   label: "Phone",
//                   controller: _phoneController,
//                   isPhone: true,
//                 ),
//                 CustomTextFieldBuilder(
//                   label: "Organization Name",
//                   controller: _organizationNameController,
//                 ),
//                 CustomTextFieldBuilder(
//                   label: "Profession",
//                   controller: _professionController,
//                 ),
//                 CustomTextFieldBuilder(
//                   label: "Skills (comma separated)",
//                   controller: _skillsController,
//                 ),
//                 CustomTextFieldBuilder(
//                   label: "City",
//                   controller: _cityController,
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _isLoading ? null : _handleSignUp,
//                   style: ElevatedButton.styleFrom(
//                     primary: Theme.of(context).primaryColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: 15),
//                   ),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       if (!_isLoading)
//                         Icon(
//                           Icons.person_add,
//                           size: 30,
//                           color: Colors.white,
//                         ),
//                       if (_isLoading)
//                         CircularProgressIndicator(
//                           valueColor:
//                               AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       if (!_isLoading)
//                         Positioned(
//                           left: 40,
//                           child: Text(
//                             "Sign Up",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 GestureDetector(
//                   onTap: _isLoading ? null : _showLoginScreen,
//                   child: Text(
//                     "Already registered? Login here",
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   Future<void> _handleSignUp() async {
//     setState(() {
//       _isLoading = true;
//     });
//     // Check if all fields are filled and valid
//     if (_nameController.text.trim().isEmpty ||
//         _emailController.text.trim().isEmpty ||
//         _passwordController.text.isEmpty ||
//         _phoneController.text.trim().isEmpty) {
//       // Show error snackbar
//       Get.snackbar(
//         'Error',
//         'Please fill all fields',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       setState(() {
//         _isLoading = false;
//       });
//       return;
//     }
//     if (!_emailController.text.trim().contains('@')) {
//       // Show error snackbar
//       Get.snackbar(
//         'Error',
//         'Please enter a valid email',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       setState(() {
//         _isLoading = false;
//       });
//       return;
//     }
//     if (_passwordController.text.length < 6) {
//       // Show error snackbar
//       Get.snackbar(
//         'Error',
//         'Password must be at least 6 characters',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       setState(() {
//         _isLoading = false;
//       });
//       return;
//     }
//     // Check if phone number is 10 digits
//     if (_phoneController.text.trim().length != 10) {
//       // Show error snackbar
//       Get.snackbar(
//         'Error',
//         'Please enter a valid phone number',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       setState(() {
//         _isLoading = false;
//       });
//       return;
//     }

//     try {
//       final UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text,
//       );

//       // check if profession is teacher then add to mentor collection
//       if (_professionController.text.trim().toLowerCase() == 'teacher') {
//         await _firebaseHelper.addMentor(
//           userId: FirebaseAuth.instance.currentUser!.uid,
//           name: _nameController.text.trim(),
//         );
//       }

//       // Add user data to Firestore using FirebaseHelper
//       await _firebaseHelper.addUser(
//         name: _nameController.text.trim(),
//         email: _emailController.text.trim(),
//         phoneNumber: _phoneController.text.trim(),
//         organization: _organizationNameController.text.trim(),
//         profession: _professionController.text.trim(),
//         skills: _skillsController.text.split(','),
//         city: _cityController.text.trim(),
//       );

//       // Navigate to HomeScreen
//       Get.off(HomeScreen());
//     } catch (e) {
//       print("Error during sign up: $e");
//       // Show error snackbar
//       Get.snackbar(
//         'Error',
//         e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _showLoginScreen() {
//     Get.to(() => LoginScreen(), transition: Transition.rightToLeft);
//   }
// }
