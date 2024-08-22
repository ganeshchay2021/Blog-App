// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:blogapp/core/theme/app_pallete.dart';

class AuthLoginSignUp extends StatelessWidget {
  final String text;
  final String textBtn;
  final VoidCallback onTap;

  const AuthLoginSignUp({
    super.key,
    required this.text,
    required this.textBtn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: Theme.of(context).textTheme.titleMedium,
        children: [
          const WidgetSpan(
            child: SizedBox(
              width: 10,
            ),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = onTap,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: AppPalette.gradient2, fontWeight: FontWeight.bold),
            text: textBtn,
          )
        ],
      ),
    );
  }
}
