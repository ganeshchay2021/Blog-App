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
      controller: controller,
      maxLines: maxLine,
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
