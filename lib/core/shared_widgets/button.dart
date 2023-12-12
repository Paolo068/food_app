import 'package:flutter/material.dart';

import '../constants/styles_constants.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? borderColor;
  final VoidCallback onPressed;
  final Color? bgColor;
  final double? width;
  final double? height;
  final bool? outlined;
  final bool? fullWidth;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.bgColor,
    this.width,
    this.height,
    this.outlined,
    this.textColor,
    this.borderColor,
    this.fullWidth,
  });

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: outlined == true ? bgColor ?? Pallete.white : Pallete.orange,
        minimumSize: Size(
          fullWidth == true ? screen.width : width ?? screen.width,
          50,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: outlined == true ? borderColor ?? Pallete.orange : Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: AppStyles.bodyText.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: outlined == true ? textColor ?? Pallete.orange : Pallete.white),
      ),
    );
  }
}
