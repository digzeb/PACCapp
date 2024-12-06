import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testt/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;

  const ChatPage({super.key, required this.receiverUserEmail, required this.receiverUserId
  });
//builds the chat page
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    //waits for a meesage then sends it
      if (_messageController.text.isNotEmpty) {
        await _chatService.sendMessage(widget.receiverUserId, _messageController.text);
        _messageController.clear(); //clears the text field after the message is sent
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail)),
      backgroundColor: Colors.grey[900],
        body: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),

            //user input
            _buildMessageInput(), 
          ],
        ),
      );
  }

  //build message list
Widget _buildMessageList() {
  return StreamBuilder(
    stream: _chatService.getMessages(
      widget.receiverUserId,
      _firebaseAuth.currentUser!.uid,
    ),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      // If there are no messages
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(
          child: Text(
            'No messages yet.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      // Build the list of messages
      return ListView.builder(
        reverse: false, // Show newest messages at the bottom
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          // Retrieve each document and pass it to _buildMessageItem
          DocumentSnapshot document = snapshot.data!.docs[index];
          return _buildMessageItem(document);
        },
      );
    },
  );
}

  //build item
Widget _buildMessageItem(DocumentSnapshot document) {
  Map<String, dynamic> data = document.data() as Map<String, dynamic>;

  // Determine alignment: Right for user, Left for others
  Alignment alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
      ? Alignment.centerRight
      : Alignment.centerLeft;

  return Container(
    alignment: alignment,
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Add spacing
    child: Column(
      crossAxisAlignment: (alignment == Alignment.centerRight)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start, // Align text accordingly
      children: [
        Text(
          data['senderEmail'] ?? 'Unknown', // Fallback in case of null
          style: TextStyle(fontSize: 12, 
          color: const Color.fromARGB(255, 255, 255, 255),
          ), // Style for email
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (alignment == Alignment.centerRight)
                ? Colors.blue[100]
                : Colors.pink[300], // Different color for user/others
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            data['message'] ?? '',
            style: const TextStyle(fontSize: 16), // Style for message text
          ),
        ),
      ],
    ),
  );
}


  //build input
Widget _buildMessageInput() {
  return Padding(
    padding: const EdgeInsets.all(10.0), // Adds space around the entire row
    child: Row(
      children: [
        // Text field
        Expanded(
          child: TextField(
            controller: _messageController,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: const InputDecoration(
              hintText: 'PACC Message',
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color.fromARGB(255, 66, 151, 220)),
              ),
            ),
            obscureText: false,
          ),
        ),
        // Send button
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(
            Icons.arrow_upward,
            color: Color.fromARGB(255, 66, 151, 220),
            size: 45,
          ),
        ),
      ],
    ),
  );
}


}