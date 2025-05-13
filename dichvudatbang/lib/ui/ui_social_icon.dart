import 'package:flutter/material.dart';

class UiSocialIcon extends StatelessWidget {
  
  final VoidCallback onTap;
  final String iconPath;

   const UiSocialIcon({
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
