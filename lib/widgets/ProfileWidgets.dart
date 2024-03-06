import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:studenthelp/components/profile.dart';

import 'package:studenthelp/settings/theme_provider.dart';
import 'package:studenthelp/utils/colors.dart';

class CustomTextProfile {
  Widget buildCustomTextProfile(String label,
      {bool isPassword = false, bool isPhone = false}) {
    return Consumer<ThemeStateProvider>(builder: (context, theme, child) {
      return Text(
        label,
        style: TextStyle(
          color:
              theme.isDarkTheme ? DarkColors.textColor : LightColors.textColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      );
    });
  }
}

class CustomTextProfileContent {
  Widget buildCustomTextProfileContent(
      ProfileScreen widget, Map<String, dynamic>? userData, String label,
      {bool isPassword = false, bool isPhone = false}) {
    return Consumer<ThemeStateProvider>(builder: (context, theme, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        child: Text(
          widget.name != 'Default'
              ? widget.name
              : label == 'skills'
                  ? userData![label].join(', ')
                  : userData![label],
          style: TextStyle(
            color: theme.isDarkTheme
                ? DarkColors.textColor
                : LightColors.textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    });
  }
}

class HorizontalThinLine {
  Widget buildHorizontalThinLine(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 2,
      width: MediaQuery.of(context).size.width / 1.2,
      color: Colors.grey[300],
    );
  }
}
