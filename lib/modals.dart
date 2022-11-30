import 'package:flutter/material.dart';

class FocusedMenuItem {
  Widget title;
  Color? backgroundColor;
  Icon? leadingIcon;
  Icon? trailingIcon;
  VoidCallback? onPressed;
  bool? isDefaultAction;

  FocusedMenuItem({
    required this.title,
    this.backgroundColor,
    this.leadingIcon,
    this.trailingIcon,
    this.onPressed,
    this.isDefaultAction = false,
  });
}
