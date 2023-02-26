import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_practice/Screen/email_auth/login_screen.dart';
import 'package:firebase_practice/Screen/email_auth/signup_screen.dart';
import 'package:firebase_practice/Screen/phone_auth/sign_in_with_phone.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // loader
  // bool loader = false;

  // Controller
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  // profile pic
  File? profilePic;

  // log out
  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SingInWithPhone(),
        ));
  }

  // save data in firebase
  void saveData() async  {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String ageString = ageController.text.trim();

    int age = int.parse(ageString);

    if (name != null && email != null && profilePic != null) {

      // setState(() {
      //   loader = true;
      // });

      UploadTask uploadTask = FirebaseStorage.instance.ref().child("Profile Pictures").child(Uuid().v1()).putFile(profilePic!);

      StreamSubscription streamSubscription = uploadTask.snapshotEvents.listen((snapshot) {
        double percentage = snapshot.bytesTransferred / snapshot.totalBytes * 100;
        print(Icons.person.toString());
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      streamSubscription.cancel();

      Map<String, dynamic> userData = {
        "name": name,
        "email": email,
        "age" : age,
        "profilePic" : downloadUrl,
      };

      FirebaseFirestore.instance.collection("users").add(userData);
      print("User created");

      // setState(() {
      //   loader = false;
      // });

      emailController.clear();
      nameController.clear();
      ageController.clear();


    } else {
      print("Please fil all the files");
    }
    // profile picture null
    setState(() {
      profilePic = null;
    });
  }

  // delete data in firebase fire store
  void deleteData(id) async{
    DocumentReference documentReference = await FirebaseFirestore.instance.collection("users").doc(id);
    documentReference.delete();
    print("Document deleted");
  }

  // init state
  // Firebase notififation

  void getInitialMessage() async{
    RemoteMessage? remoteMessage =  await FirebaseMessaging.instance.getInitialMessage();
    if(remoteMessage != null){
      if(remoteMessage.data["page"] == "email"){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupScreen(),));
      }
      else if(remoteMessage.data["page"] == "phone"){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SingInWithPhone(),));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Invalid page!"),
          duration: Duration(seconds: 10),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();

    getInitialMessage();

    FirebaseMessaging.onMessage.listen((event) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(event.data["myname"].toString()),
        duration: Duration(seconds: 10),
        backgroundColor: Colors.green,
      ));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("App was opened by notification"),
        duration: Duration(seconds: 10),
        backgroundColor: Colors.green,
      ));
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Home Screen"),
        actions: [
          IconButton(
            onPressed: () {
              logOut();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      // body
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        // images
                        GestureDetector(
                          onTap: () async {
                            XFile? selectedImage =  await ImagePicker().pickImage(source: ImageSource.gallery);
                            if(selectedImage != null){
                              File convertedFile = File(selectedImage.path);
                              setState(() {
                                profilePic = convertedFile;
                              });
                              print("Image selected!");
                            }
                            else{
                              print("No image select.");
                            }
                          },
                          child: CircleAvatar(
                            backgroundImage: (profilePic != null) ? FileImage(profilePic!) : null,
                            backgroundColor: Colors.blue,
                            radius: 55,
                          ),
                        ),
                        SizedBox(height: 5,),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: "Name",
                              label: Text("Name"),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: TextField(
                            controller: ageController,
                            decoration: InputDecoration(
                              hintText: "Age",
                              label: Text("Age"),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        // button
                        GestureDetector(
                          onTap: () {
                              saveData();
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
                                "Save",
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
                ),
                // SizedBox(
                //   height: 10,
                // ),

                // data fatch
                StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection("users").orderBy("age", descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> userDataMap =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;

                              return Card(
                                elevation: 3,
                                child: ListTile(
                                  title: Text(userDataMap["name"] + " (${userDataMap["age"]})"),
                                  subtitle: Text(userDataMap["email"]),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(userDataMap["profilePic"]),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      // delete data in firebase fire store
                                      print("Delete");
                                      deleteData(snapshot.data!.docs[index].id);
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Text("No data!");
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
