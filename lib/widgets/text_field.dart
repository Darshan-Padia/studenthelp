import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthelp/settings/theme_provider.dart';

class CustomTextFieldBuilder {
  Widget buildTextField(String label, TextEditingController controller,
      {bool isPassword = false, bool isPhone = false}) {
    return Consumer<ThemeStateProvider>(builder: (context, theme, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextFormField(
          keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
          controller: controller,
          obscureText: isPassword,
          style: TextStyle(
            // color: according to theme,
            color: theme.isDarkTheme ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              // color: according to theme,
              color: theme.isDarkTheme ? Colors.white : Colors.black,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );
    });
  }
}
