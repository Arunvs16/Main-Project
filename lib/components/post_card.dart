import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  String timeAgo, caption, imageUrl;
  final void Function()? onPressed;
  PostCard({
    super.key,
    required this.caption,
    required this.timeAgo,
    required this.imageUrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 2),
          color: Theme.of(context).colorScheme.secondary),
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // profile pic
                      Container(
                        margin: EdgeInsets.only(left: 10, top: 10),
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.height * 0.05,
                        child: CircleAvatar(
                          backgroundImage: AssetImage('images/person.jpg'),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        margin: EdgeInsets.only(left: 1, top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // username
                            Text(
                              'usename',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // post time
                            Text(
                              timeAgo,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // delete
                  IconButton(
                      onPressed: onPressed,
                      icon: Icon(
                        Icons.delete,
                      ))
                ],
              ),
              Row(
                children: [
                  // caption
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: Text(caption),
                  ),
                ],
              ),

              // image
              Container(
                height: MediaQuery.of(context).size.height * .55,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  height: MediaQuery.of(context).size.height * .50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.green),
                  child: Image.network(
                    imageUrl,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        child: Icon(Icons.error_outline),
                      );
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.blue,
                height: MediaQuery.of(context).size.height * .0,
                width: MediaQuery.of(context).size.width,
              )
            ],
          ),
        ],
      ),
    );
  }
}
