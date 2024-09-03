import 'package:flutter/material.dart';

class OpenPostImage extends StatelessWidget {
  final String timeAgo, caption, imageURL, username, postId;
  final void Function()? onPressedDlt;
  const OpenPostImage({
    super.key,
    required this.caption,
    required this.username,
    required this.timeAgo,
    required this.imageURL,
    required this.onPressedDlt,
    required this.postId,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary, width: 1),
                  ),
                  height: MediaQuery.of(context).size.height * 1,
                  child: Column(
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
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    width: MediaQuery.of(context).size.height *
                                        0.05,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          AssetImage('images/person.jpg'),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    margin: EdgeInsets.only(left: 1, top: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // username
                                        Text(
                                          username,
                                          style: TextStyle(
                                            // fontSize: 20,
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

                              // options
                              IconButton(
                                onPressed: onPressedDlt,
                                icon: Icon(
                                  Icons.more_vert,
                                ),
                              )
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
                            decoration: BoxDecoration(),
                            height: MediaQuery.of(context).size.height * .60,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              height: MediaQuery.of(context).size.height * .50,
                              width: MediaQuery.of(context).size.width,
                              decoration:
                                  BoxDecoration(color: Colors.transparent),
                              child: Image.network(
                                imageURL,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(),
                                    child: Icon(Icons.error_outline),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
  }
}