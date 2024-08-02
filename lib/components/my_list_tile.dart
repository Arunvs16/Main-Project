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
  Color? color1;
  Color? color2;

  MyListTile({
    super.key,
    required this.onTap,
    required this.horizontal,
    required this.vertical,
    required this.leading,
    required this.titleText,
    required this.subTitleText,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      
      child: ListTile(
          leading: leading,
          title: Text(
            titleText,
            style: TextStyle(color: color1),
          ),
          subtitle: Text(
            subTitleText,
            style: TextStyle(color: color2),
          ),
          onTap: onTap),
    );
  }
}
