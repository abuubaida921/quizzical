import 'package:flutter/material.dart';

class EmptyRadioWidget extends StatelessWidget {
  const EmptyRadioWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black54, width: 1.6),
      ),
      margin: const EdgeInsets.only(left: 12),
    );
  }
}