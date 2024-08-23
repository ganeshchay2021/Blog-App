import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int? maxLine;
  const BlogEditor({
    super.key,
    required this.controller,
    required this.hintText,
     this.maxLine=1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if(value!.trim().isEmpty){
          return "$hintText is missing";
        }
        return null;
      },
      controller: controller,
      maxLines: maxLine,
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
