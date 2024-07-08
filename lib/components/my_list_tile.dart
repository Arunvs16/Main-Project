import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  void Function()? onTap;
  // double left;
  // double right;
  // double top;
  // double bottom;
  double horizontal;
  double vertical;
  Widget? leading;
  String titleText;
  String subTitleText;
  Color? color;

  MyListTile({
    super.key,
    required this.onTap,
    // required this.left,
    // required this.right,
    required this.horizontal,
    required this.vertical,
    required this.leading,
    required this.titleText,
    required this.subTitleText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        // left: left,
        // right: right,
        horizontal: horizontal,
        vertical: vertical,
      ),
      
      child: ListTile(
          leading: leading,
          title: Text(
            titleText,
            style: TextStyle(color: color),
          ),
          subtitle: Text(
            subTitleText,
            style: TextStyle(color: color),
          ),
          onTap: onTap),
    );
  }
}
