import 'package:flutter/material.dart';

class SelectionTile extends StatelessWidget {
  final bool value;
  final bool active;
  final Widget title;
  final Widget? subtitle;
  final VoidCallback onTap;
  final Widget? traling;
  SelectionTile(
      {required this.value,
      required this.onTap,
      required this.title,
      this.traling,
      this.subtitle,
      this.active = true});
  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      secondary: traling,
      value: value,
      title: title,
      subtitle: subtitle,
      selected: value,
      groupValue: value ? value : !value,
      onChanged: active ? (v) => onTap() : null,
    );
  }
}
