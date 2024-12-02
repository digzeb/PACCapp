import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testt/services/auth/login_or_register.dart';

import '../../pages/home_page.dart';

class Authgate extends StatelessWidget {
  const Authgate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //logged in user
          if (snapshot.hasData) {
            return const HomePage();
          }


          //user not logged in
          else {
            return const LoginOrRegister();
          }
        }

      )
    );
  }
}