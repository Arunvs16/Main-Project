import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/components/chat_bubbles.dart';
import 'package:main_project/components/my_text_field.dart';
import 'package:main_project/services/chat_services.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverId;
  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverId,
  });

  // text controller

  final TextEditingController _messageController = TextEditingController();

  // chat & auth services

  final ChatService _chatService = ChatService();

  final FirebaseAuth auth = FirebaseAuth.instance;

  // currentuser

  final User currentUser = FirebaseAuth.instance.currentUser!;

  // send message
  void sendMessage() async {
    // if there is something inside the textfield
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(receiverId, _messageController.text);
    }

    // clear the controller
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: ListTile(
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
          title: Text(receiverEmail),
        ),
      ),
      body: Column(
        children: [
          // display all the messages
          Expanded(
            child: _buildMessageList(),
          ),

          // user input
          _buildUserInput(context),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    String senderId = currentUser.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverId, senderId),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return Center(
            child: Text('Error'),
          );
        }

        // loading
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // has no data
        else if (snapshot.data == null) {
          return Center(
            child: Text('No messages'),
          );
        }

        // has data
        else {
          // return a list view
          return ListView(
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        }
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data['senderId'] == auth.currentUser!.uid;

    // align message to right if sender is the current user, otherwise left

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubbles(
            message: data['message'],
            isCurrentUser: isCurrentUser,
          ),
        ],
      ),
    );
  }

  // build user input
  Widget _buildUserInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        children: [
          // text field should take up most of the space
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Type Something',
              obscureText: false,
            ),
          ),

          // send button
          Container(
            margin: EdgeInsets.only(right: 25),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            child: IconButton(
              onPressed: () {
                sendMessage();
              },
              icon: Icon(Icons.send),
            ),
          )
        ],
      ),
    );
  }
}
