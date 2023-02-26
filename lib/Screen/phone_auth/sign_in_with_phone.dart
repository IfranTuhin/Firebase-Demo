import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/Screen/phone_auth/verify_otp.dart';
import 'package:flutter/material.dart';

class SingInWithPhone extends StatefulWidget {
  const SingInWithPhone({Key? key}) : super(key: key);

  @override
  State<SingInWithPhone> createState() => _SingInWithPhoneState();
}

class _SingInWithPhoneState extends State<SingInWithPhone> {
  TextEditingController phoneNumberController = TextEditingController();

  // send OTP
  void sendOTP() async {
    String phoneNumber = "+88" + phoneNumberController.text.trim();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (verificationId, forceResendingToken) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyOTP(
                verificationId: verificationId,
              ),
            ));
      },
      verificationCompleted: (phoneAuthCredential) {},
      verificationFailed: (error) {
        print(error.message);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
      timeout: Duration(seconds: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sing in with phone"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  label: Text("Phone Number"),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // button
            GestureDetector(
              onTap: () {
                sendOTP();
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
                    "Sign In",
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
