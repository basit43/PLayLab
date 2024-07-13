import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/my_strings.dart';
import 'core/di_service/di_service.dart' as di_service;
import 'core/helper/messages.dart';
import 'core/route/route.dart';
import 'core/theme/dark.dart';
import 'core/utils/my_color.dart';
import 'data/controller/localization/localization_controller.dart';
import 'push_notification_service.dart';
import 'shared_preference_class.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> _messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(name: 'playlab-55c29');
}

void main() async {
  print("Initializing the app");
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'anandguruvani-007',
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAOksJ_D3GNYR_uT1dlgWpY1V4XKb4wwG0',
      appId: '1:937461069265:android:14dbfe5ee116546845dcf0',
      messagingSenderId: '937461069265',
      projectId: 'anandguruvani-007',
      storageBucket: 'anandguruvani-007.appspot.com',
    ),
  );

  MySharedPrefClass.preferences = await SharedPreferences.getInstance();

  MobileAds.instance.initialize();
  Map<String, Map<String, String>> languages = await di_service.init();

  // Set up the background message handler
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  // Set up the interacted message for push notifications
  await PushNotificationService().setupInteractedMessage();

  // Override HTTP globally
  HttpOverrides.global = MyHttpOverrides();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: MyColor.colorGrey3,
    statusBarColor: MyColor.secondaryColor,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // Read the logged-in state from SharedPreferences
  bool isLoggedIn = MySharedPrefClass.preferences?.getBool("loggedIn") ?? false;

  // Determine initial route based on login state
  String initialRoute =
      isLoggedIn ? RouteHelper.homeScreen : RouteHelper.splashScreen;

  // Initialize the app with the determined initial route
  runApp(MyApp(
    languages: languages,
    initialRoute: initialRoute,
  ));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  final String initialRoute;

  const MyApp({
    Key? key,
    required this.languages,
    required this.initialRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      builder: (localizeController) {
        return GetMaterialApp(
          title: MyStrings.appName,
          initialRoute: initialRoute,
          defaultTransition: Transition.topLevel,
          transitionDuration: const Duration(milliseconds: 50),
          getPages: RouteHelper.routes,
          navigatorKey: Get.key,
          debugShowCheckedModeBanner: false,
          locale: localizeController.locale,
          // theme: dark,
          translations: Messages(languages: languages),
          fallbackLocale: Locale(
            localizeController.locale.languageCode,
            localizeController.locale.countryCode,
          ),
        );
      },
    );
  }
}
