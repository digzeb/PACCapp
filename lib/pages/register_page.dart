import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testt/components/my_button.dart';
import 'package:testt/components/my_text_field.dart';
import 'package:testt/services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
   final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //sign up method
  void signUp() async{
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The Passwords entered do not match'),
      ),
       );
       return;
    }

    //get auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signUpWithEmailandPassword(
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
                //logo
                Image.asset(
              'assets/PACC.jpg',
              width: 150,          // Set the width as needed
              height: 150,          // Set the height as needed
                ),
                    
              
                const SizedBox(height: 70),
            
              //welcome
              const Text("Let's Get You Signed Up!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold
                
              ),
              ),

              const SizedBox(height: 5),
                    
              //email
              MyTextField(
                controller: emailController, 
                hintText: 'Email', 
                obscureText: false,
                ),
            
                    
              //password
              MyTextField(
                controller: passwordController, 
                hintText: 'Password', 
                obscureText: true,
                ),      
              //login button
              const SizedBox(height: 0),

              //Confirm password
              MyTextField(
                controller: confirmPasswordController, 
                hintText: 'Confirm Password', 
                obscureText: true,
                ), 
                const SizedBox(height: 25),

              MyButton(onTap: signUp, text: "Sign Up")
              //register button

              ,const SizedBox(height: 15),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already a member?',

                  style: TextStyle(
                      color: Colors.white,
                    ),
                    ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Log In Now',
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