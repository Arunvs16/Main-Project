import 'package:flutter/material.dart';
import 'package:main_project/components/my_list_tile.dart';

class UserTile extends StatelessWidget {
  final String username;
  final String text;
  final void Function()? onTap;
  const UserTile({
    super.key,
    required this.username,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MyListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image(
          fit: BoxFit.cover,
          image: AssetImage('images/person.jpg'),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          errorBuilder: (context, object, stack) {
            return Container(
              child: Icon(Icons.error_outline),
            );
          },
        ),
      ),
      titleText: username,
      subTitleText: text,
      horizontal: 0,
      vertical: 5,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
