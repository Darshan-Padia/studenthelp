import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:studenthelp/components/login.dart';
import 'package:studenthelp/helper/firebase_helper.dart';
import 'package:studenthelp/settings/theme_provider.dart';
import 'package:studenthelp/utils/colors.dart';
import 'package:studenthelp/widgets/ProfileWidgets.dart';

class ProfileScreen extends StatefulWidget {
  // const ProfileScreen({Key? key}) : super(key: key);
  final String name;
  final String email;
  final String phoneNumber;
  final String organization;
  final String profession;
  final List<String> skills;
  final String city;

  const ProfileScreen({
    Key? key,
    this.name = 'Default',
    this.email = 'Default',
    this.phoneNumber = 'Default',
    this.organization = 'Default',
    this.profession = 'Default',
    this.skills = const ['Default'],
    this.city = 'Default',
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// name,email,phone
class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = true;
  // GetStorage box = GetStorage();

  Map<String, dynamic>? userData;
  String? username = FirebaseAuth.instance.currentUser!.displayName;
  String? emaill = FirebaseAuth.instance.currentUser!.email;
  @override
  void initState() {
    super.initState();

// THIS IS DONE TO USE THIS PROFILE SCREEN WITH OTHER COMPONENETS THAT IS
// WHEN OWNER SEES HIS PROFILE THE DEFAULT THING IS TRUE
// BUT WHEN USER SEES OTHER USER'S PROFILE THE DEFAULT THING IS FALSE
    if (widget.name == 'Default' &&
        widget.email == 'Default' &&
        widget.phoneNumber == 'Default') {
      _getUserData();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getUserData() async {
    // String organizationId;
    String id = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseHelper().getUserData(id).then((value) {
      if (value != null) {
        setState(() {
          userData = value.toJson();
          isLoading = false;
        });
      } else {
        // Handle case when user data is not found
        print('User data not found');
      }
    }).catchError((error) {
      // Handle error if any
      print('Error retrieving user data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    // DarkColors

    return Consumer<ThemeStateProvider>(builder: (context, theme, child) {
      return Scaffold(
        backgroundColor: theme.isDarkTheme
            ? DarkColors.scaffoldBgColor
            : LightColors.scaffoldBgColor,
        appBar: AppBar(
          title: Text(
            'Profile',
            style: GoogleFonts.poppins(
              color: theme.isDarkTheme
                  ? DarkColors.textColor
                  : LightColors.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: theme.isDarkTheme
                  ? DarkColors.textColor
                  : LightColors.textColor,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  _buildCoverImage(context),
                  _buildProfilePicture(context),
                ],
              ),
              _buildProfileContent(context),
              const SizedBox(height: 20),
              // Add a theme switcher

              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCoverImage(BuildContext context) {
    return Column(
      children: [
        Container(
          height: (MediaQuery.of(context).size.height / 3),
          width: double.infinity,
          // color: gradient, // You can replace this with your image
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorDark,
                Theme.of(context).primaryColorLight,
              ],
            ),
          ),

          // You can add other properties like decoration, etc. for the cover image
        ),
        // transparent sized box as a placeholder for the profile picture
        const SizedBox(height: 52),
      ],
    );
  }

  Widget _buildProfilePicture(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height / 3.5,
      left: MediaQuery.of(context).size.width / 2 - 50,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 3.0,
          ),
          // You can add other properties like decoration, etc. for the circular image
        ),
        child: ClipOval(
          child: Image.network(
            'https://cdn4.vectorstock.com/i/1000x1000/20/38/hand-making-small-heart-sign-vector-28932038.jpg', // Replace with your image URL
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    // var themeController = Get.find<ThemeController>();
    return Consumer<ThemeStateProvider>(builder: (context, theme, child) {
      return Padding(
        padding: //only left and right padding
            const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to the left
                  children: [
                    CustomTextProfile().buildCustomTextProfile('Name'),
                    CustomTextProfileContent().buildCustomTextProfileContent(
                        widget, userData, 'name'),
                    HorizontalThinLine().buildHorizontalThinLine(context),

                    CustomTextProfile().buildCustomTextProfile('Email'),
                    CustomTextProfileContent().buildCustomTextProfileContent(
                        widget, userData, 'email'),
                    HorizontalThinLine().buildHorizontalThinLine(context),

                    CustomTextProfile().buildCustomTextProfile('Phone'),
                    CustomTextProfileContent().buildCustomTextProfileContent(
                        widget, userData, 'phoneNumber'),
                    HorizontalThinLine().buildHorizontalThinLine(context),

                    CustomTextProfile().buildCustomTextProfile('rganization'),
                    CustomTextProfileContent().buildCustomTextProfileContent(
                        widget, userData, 'organization'),
                    HorizontalThinLine().buildHorizontalThinLine(context),

                    CustomTextProfile().buildCustomTextProfile('Profession'),
                    CustomTextProfileContent().buildCustomTextProfileContent(
                        widget, userData, 'profession'),
                    HorizontalThinLine().buildHorizontalThinLine(context),

                    CustomTextProfile().buildCustomTextProfile('Skills'),
                    CustomTextProfileContent().buildCustomTextProfileContent(
                        widget, userData, 'skills'),
                    HorizontalThinLine().buildHorizontalThinLine(context),

                    CustomTextProfile().buildCustomTextProfile('City'),
                    CustomTextProfileContent().buildCustomTextProfileContent(
                        widget, userData, 'city'),
                    HorizontalThinLine().buildHorizontalThinLine(context),

                    const SizedBox(height: 20),

                    // Add a theme switcher
                    widget.name == 'Default'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Dark Mode',
                                style: TextStyle(
                                  color: theme.isDarkTheme
                                      ? DarkColors.textColor
                                      : LightColors.textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 10),
                              CupertinoSwitch(
                                value: theme.isDarkTheme,
                                onChanged: (val) {
                                  theme.setDarkTheme();
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    // add logout button
                    const SizedBox(height: 20),
                    widget.name == 'Default'
                        ? Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Get.offAll(() => LoginScreen());
                              },
                              style: ElevatedButton.styleFrom(
                                primary: //transparent, // Background color
                                    Colors.blue[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.logout,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  Positioned(
                                    left: 40,
                                    child: Text(
                                      "Logout",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
        ),
      );
    });
  }
}
