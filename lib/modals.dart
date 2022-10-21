import 'package:flutter/material.dart';

class FocusedMenuItem {
  Widget title;
  Color? backgroundColor;
  Icon? leadingIcon;
  Icon? trailingIcon;
  VoidCallback? onPressed;

  FocusedMenuItem({
    required this.title,
    this.backgroundColor,
    this.leadingIcon,
    this.trailingIcon,
    this.onPressed,
  });
}
