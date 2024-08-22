// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:blogapp/core/theme/app_pallete.dart';

class AuthGradientButton extends StatelessWidget {
  final String btnText;
  final VoidCallback onTap;
  const AuthGradientButton({
    super.key,
    required this.btnText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(colors: [
          AppPalette.gradient1,
          AppPalette.gradient2,
          AppPalette.gradient3
        ], begin: Alignment.bottomLeft, end: Alignment.topRight),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: AppPalette.transparentColor,
          backgroundColor: AppPalette.transparentColor,
          fixedSize: const Size(395, 55),
        ),
        onPressed: onTap,
        child: Text(
          btnText,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
