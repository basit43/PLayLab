import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'core/route/route.dart';

class MySharedPrefClass {
  static SharedPreferences? preferences;
  static final FirebaseAuth _auth = FirebaseAuth.instance;


  // static void logout() {
  //   preferences?.remove("loggedIn");
  // }


  static void logout(context) async {
    try {
      print("Logout");
      await _auth.signOut();
      print("Logout1");
      preferences?.remove("loggedIn");
      Navigator.pushReplacementNamed(context, RouteHelper.splashScreen);
    } catch (e) {
      print("Error logging out: $e");
    }
  }


}