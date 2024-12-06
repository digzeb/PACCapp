import 'package:testt/components/my_button.dart';
import 'package:testt/components/my_text_field.dart';
import 'package:testt/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //sign in function
  void signIn() async {
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try { 
      await authService.signInWithEmailandPassword(
        emailController.text, 
        passwordController.text
        );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
          ),
        
        
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(

              children: [
                const SizedBox(height: 90),
                Image.asset(
                  'assets/PACC.jpg',//Our logo shown above the login
                  width: 150,
                  height: 150,
                  ),
                    
              
                const SizedBox(height: 70),
            
              //welcome Text
              const Text("Welcome To PACC",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold
                
              ),
              ),

              const SizedBox(height: 5),
                    
              //email button
              MyTextField(
                controller: emailController, 
                hintText: 'Email', 
                obscureText: false,
                ),
            
                    
              //password button
              MyTextField(
                controller: passwordController, 
                hintText: 'Password', 
                obscureText: true,

                ),      
              //login button
              const SizedBox(height: 25),

              MyButton(onTap: signIn, text: "Sign In")
              //register button to allow the user to sign up

              ,const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not a member?',
                  style: TextStyle(
                      color: Colors.white,),),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Register Now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                    ],
                )
              ], 
                    ),
          ),
      ),
    )
    );
  }
}