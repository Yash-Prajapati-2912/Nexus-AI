import 'package:flutter/material.dart';

class ExpandableListTile extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? leading;

  const ExpandableListTile({
    super.key,
    required this.title,
    required this.children,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: leading,
      title: Text(title),
      children: children,
    );
  }
}
