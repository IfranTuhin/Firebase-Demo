import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_practice/Screen/home_screen.dart';
import 'package:flutter/material.dart';


class VerifyOTP extends StatefulWidget {
  final String verificationId;
  const VerifyOTP({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {

  // Controller
  TextEditingController otpController = TextEditingController();

  bool loader = false;

  // verify otp
  void verifyOtp() async{
    String otp = otpController.text.trim();

    PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otp);

    try{
      setState(() {
        loader = true;
      });
      UserCredential userCredential =  await FirebaseAuth.instance.signInWithCredential(authCredential);
      if(userCredential.user != null){
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
        setState(() {
          loader = false;
        });
      }
    }on FirebaseAuthException catch(authException){
      print(authException.message.toString());
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify OTP"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: TextField(
                controller: otpController,
                maxLength: 6,
                decoration: InputDecoration(
                  counterText: "",
                  hintText: "6-digit OTP",
                  label: Text("6-digit OTP"),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // button
            loader ? Center(child: CircularProgressIndicator(),) : GestureDetector(
              onTap: () {
                verifyOtp();
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
