import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthelp/settings/theme_provider.dart';
import 'package:flutter/cupertino.dart';

class CustomTextFieldBuilder extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final bool isPhone;

  const CustomTextFieldBuilder({
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.isPhone = false,
  });

  @override
  _CustomTextFieldBuilderState createState() => _CustomTextFieldBuilderState();
}

class _CustomTextFieldBuilderState extends State<CustomTextFieldBuilder> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeStateProvider>(
      builder: (context, theme, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CupertinoTextField(
            style: TextStyle(
              color: theme.isDarkTheme ? Colors.white : Colors.black,
              fontSize: 25, // Adjust the font size as needed
            ),
            controller: widget.controller,
            placeholder: widget.label,
            obscureText: widget.isPassword,
            keyboardType:
                widget.isPhone ? TextInputType.phone : TextInputType.text,
            decoration: BoxDecoration(
              color: theme.isDarkTheme ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}
