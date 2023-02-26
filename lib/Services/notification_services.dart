import 'package:firebase_messaging/firebase_messaging.dart';

// background message handler
Future<void> backgroundHandler(RemoteMessage remoteMessage) async{
  print("Message received ${remoteMessage.notification!.title}");
}

class NotificationServices{

  static Future<void> initialize() async{
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      
      FirebaseMessaging.onBackgroundMessage(backgroundHandler);


      print("Notifications initialize!");
    }
  }

}