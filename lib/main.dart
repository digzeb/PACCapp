import 'package:flutter/material.dart';
import 'package:testt/firebase_options.dart';
import 'package:testt/services/auth/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:testt/services/auth/auth_service.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(create: (context) => AuthService(), child: const MyApp(),)
    // this is the main app widget
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Authgate(),
    );
  }
}