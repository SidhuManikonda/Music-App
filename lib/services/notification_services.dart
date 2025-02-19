// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:myportifolio/main.dart';

// class NotificationServices {
//   static Future<void> initializeNotification() async {
//     await AwesomeNotifications().initialize(
//       null,
//       [
//         NotificationChannel(
//             channelKey: "high_importance_channel",
//             channelGroupKey: "high_importance_channel",
//             channelName: "Basic Notifications",
//             channelDescription: "Notification channel for basic tests",
//             defaultColor: const Color(0xFF9D50DD),
//             ledColor: Colors.white,
//             importance: NotificationImportance.Max,
//             channelShowBadge: true,
//             onlyAlertOnce: true,
//             playSound: true,
//             criticalAlerts: true)
//       ],
//       channelGroups: [
//         NotificationChannelGroup(
//             channelGroupKey: "high_importance_channel_group",
//             channelGroupName: 'Group 1')
//       ],
//       debug: true,
//     );
//     await AwesomeNotifications()
//         .isNotificationAllowed()
//         .then((isAllowed) async {
//       if (!isAllowed) {
//         await AwesomeNotifications().requestPermissionToSendNotifications();
//       }
//     });
//     await AwesomeNotifications().setListeners(
//         onActionReceivedMethod: onActionReceivedMethod,
//         onNotificationCreatedMethod: onNotificationCreatedMethod,
//         onNotificationDisplayedMethod: onNotificationDisplayedMethod,
//         onDismissActionReceivedMethod: onDismissActionReceivedMethod);
//   }

//   static Future<void> onNotificationCreatedMethod(
//       ReceivedNotification receivedNotification) async {
//     debugPrint("onNotificationCreatedMethod");
//   }

//   static Future<void> onNotificationDisplayedMethod(
//       ReceivedNotification receivedNotification) async {
//     debugPrint("onNotificationDisplayedMethod");
//   }

//   static Future<void> onDismissActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     debugPrint("onDismissActionReceivedMethod");
//   }

//   static Future<void> onActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     debugPrint("onNotificationCreatedMethod");
//     final payload=receivedAction.payload??{};
//     if(payload['navigate']=='true'){
//       MyApp.navigatorkey.currentState
//     }
//   }
// }

















// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// // class NotificationService {
// //   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
// //   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
// //       FlutterLocalNotificationsPlugin();

// //   Future<void> initialize() async {
// //     const AndroidNotificationChannel channel = AndroidNotificationChannel(
// //       'chat_messages', 
// //       'Chat Notifications', 
// //       importance: Importance.max,
// //       sound: RawResourceAndroidNotificationSound('notification_sound'),
// //     );

// //     await _flutterLocalNotificationsPlugin
// //         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
// //         ?.createNotificationChannel(channel);
// //     await _fcm.requestPermission();
// //     final token = await _fcm.getToken();
// //     print('FCM Token: $token');

   
// //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
// //       _showNotification(message);
// //     });

// //     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
// //   }

// //   static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  
// //   }

// //   void _showNotification(RemoteMessage message) {
// //     const AndroidNotificationDetails androidPlatformChannelSpecifics =
// //         AndroidNotificationDetails(
// //       'chat_messages', 
// //       'Chat Notifications',
// //       importance: Importance.max,
// //       priority: Priority.high,
// //     );

// //     const NotificationDetails platformChannelSpecifics =
// //         NotificationDetails(android: androidPlatformChannelSpecifics);

// //     _flutterLocalNotificationsPlugin.show(
// //       0,
// //       message.notification?.title,
// //       message.notification?.body,
// //       platformChannelSpecifics,
// //     );
// //   }
// // }