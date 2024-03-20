import 'package:flutter/material.dart';

import '../theme/colors.dart';

class AppIconBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final Icon? icon;
  final Color? borderColor;
  final Color? bgColor;

  const AppIconBtn({super.key, this.onPressed, this.icon, this.borderColor, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      onPressed: onPressed,
      icon: icon ?? const Text(''),
      style: IconButton.styleFrom(backgroundColor: bgColor, side: BorderSide(color: borderColor ?? Pallete.darkBlue)),
    );
  }
}
