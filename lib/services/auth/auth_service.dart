import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier{
  // instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign in with email and password
  Future<UserCredential> signInWithEmailandPassword(String email, String password) async {
    try {
      //sign in
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password,
      );

      // new doc for user
      _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email, 
          }, SetOptions(merge: true));
      return userCredential;

    
  } 
  //catch error
  on FirebaseAuthException catch (e) {
    throw Exception(e.code);
}
}
  Future<UserCredential> signUpWithEmailandPassword(String email, password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
        );//sign up

        // after creating user, new doc for user
        _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email
        });//set options
        
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } //catch error and throw exception
  }  
  // sign out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

}