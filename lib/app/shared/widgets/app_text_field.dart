// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? suffix;
  final Widget? prefix;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.focusNode,
    this.keyboardType,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.suffixIcon,
    this.suffix,
    this.prefix,
    this.prefixIcon,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon,
        prefix: prefix,
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: suffixIcon,
        suffix: suffix,
      ),
    );
  }
}
