import 'dart:math';
import 'dart:developer';

import 'package:firebase_practice/Screen/email_auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  //loader
  bool loader = false;
  // controller
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void createAccount() async {

    var email = emailController.text.trim();
    var password = passwordController.text.trim();
    var confirmPassword = confirmPasswordController.text.trim();

    if (email == "" || password == "" || confirmPassword == "") {
      print("Please fill all the details!");
    } else if (password != confirmPassword) {
      print("Password do not match!");
    } else {
      // create new account
      try{
        setState(() {
          loader = true;
        });
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if(userCredential.user != null){
          Navigator.pop(context);
        }
        //print("Successfully Created");
        setState(() {
          loader = false;
        });
        //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
      }on FirebaseAuthException catch(authException){
        print(authException.message);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create an account"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  label: Text("Email"),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                  label: Text("Password"),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  label: Text("Confirm Password"),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            loader ? Center(child: CircularProgressIndicator(),) : GestureDetector(
              onTap: () {
                createAccount();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  alignment: Alignment.center,
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
