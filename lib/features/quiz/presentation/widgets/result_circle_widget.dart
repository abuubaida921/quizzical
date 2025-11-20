import 'package:flutter/material.dart';

class ResultCircleWidget extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconColor;

  const ResultCircleWidget({
    required this.color,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: iconColor),
    );
  }
}