import 'package:flutter/material.dart';

class CollectonCard extends StatelessWidget {
  final void Function()? onTap;
  final Color? containerColor;
  final Color? textColor;
  final String text;
  const CollectonCard({
    super.key,
    required this.onTap,
    required this.containerColor,
    required this.textColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 100,
        margin: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
