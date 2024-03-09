import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthelp/settings/theme_provider.dart';

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
          child: TextFormField(
            onChanged: (value) {
              setState(() {
                // Notify listeners here if needed
              });
            },
            keyboardType:
                widget.isPhone ? TextInputType.phone : TextInputType.text,
            controller: widget.controller,
            obscureText: widget.isPassword,
            style: TextStyle(
              color: theme.isDarkTheme ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: TextStyle(
                color: theme.isDarkTheme ? Colors.white : Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        );
      },
    );
  }
}
