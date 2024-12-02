import 'dart:isolate';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testt/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // auth service
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // signing out the user

  void signOut() {
    // auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
    
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        actions: [
          // logout button
          IconButton(
            onPressed: signOut, 
            icon: const Icon(Icons.logout),
            )
        ],
        ),
        body: _buildUserList(),
    );
  }

  // build user list, not current logged
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('users').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Text('ERROR');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text('Loading...');
      }

      return ListView(
        children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc))
        .toList(),
      );
      },
    );
  }

  //build individual user list item
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // display aal except current user
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          // pass user ID to chat
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserId: data['uid'],
                receiverUserEmail: data['email'],
                
              
            ),

          )
          );

          
        }
      );
    } else {
      // return empty container
      return Container();
    }

  }

  //

}