import 'package:flutter/material.dart';

class SocialIconUi extends StatelessWidget {
  
  final VoidCallback onTap;
  final String iconPath;

   const SocialIconUi({
    Key? key,
    required this.onTap,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onTap: onTap,
      child: Image.asset(
        iconPath,
        width: 40,
      ),
    );
  }
}
