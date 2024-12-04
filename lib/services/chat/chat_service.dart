import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../model/message.dart';


class ChatService extends ChangeNotifier {

  //auth and firestore instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //send message
  Future<void> sendMessage(String receiverId, String message) async {
    // get user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final formattedTime = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(formattedTime);

    //create new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );

    // chat room id between sender and receiver
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); //makes sure chat room id for two people is the same
    String chatRoomId = ids.join("_"); //creates a single id string from the two 

    //new message added to database
    await _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
    
  }

  //receive message
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    // creates a chat room from the two ids
    List<String> ids = [userId, otherUserId];
    ids.sort(); //makes sure chat room id for two people is the same
    String chatRoomId = ids.join("_"); //creates a single id string from the two 
    return _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}