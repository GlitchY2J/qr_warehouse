import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormTextField extends StatelessWidget {
  const CustomFormTextField({
    super.key,
    required this.controller,
    this.width = 400,
    this.obscureText = false,
    this.hintText,
    this.validator,
    this.textInputType,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.maxLength,
    this.interactiveSelection,
    this.enabled,
    this.onChanged,
    this.focusNode,
  });

  final TextEditingController controller;
  final double? width;
  final bool obscureText;
  final bool? enabled;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;
  final int? maxLength;
  final bool? interactiveSelection;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        focusNode: focusNode,
        obscureText: obscureText,
        enabled: enabled,
        maxLength: maxLength,
        controller: controller,
        keyboardType: textInputType,
        inputFormatters: inputFormatters,
        enableInteractiveSelection: interactiveSelection,
        enableSuggestions: false,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          suffixIcon: suffixIcon,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade400),
          ),
        ),
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
      ),
    );
  }
}
