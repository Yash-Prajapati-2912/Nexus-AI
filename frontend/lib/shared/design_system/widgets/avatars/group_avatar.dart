import 'package:flutter/material.dart';

class GroupAvatar extends StatelessWidget {
  final List<String> names;
  final double radius;

  const GroupAvatar({
    super.key,
    required this.names,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final displayNames = names.take(3).toList();
    return SizedBox(
      width: radius * 2 + (displayNames.length - 1) * (radius * 1.2),
      height: radius * 2,
      child: Stack(
        children: List.generate(
          displayNames.length,
          (index) => Positioned(
            left: index * (radius * 1.2),
            child: CircleAvatar(
              radius: radius,
              child: Text(displayNames[index][0]),
            ),
          ),
        ),
      ),
    );
  }
}
