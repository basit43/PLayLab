import 'package:flutter/services.dart';

import 'my_color.dart';

class MyUtil{

   static changeTheme(){
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: MyColor.colorBlack,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: MyColor.colorBlack,
        systemNavigationBarIconBrightness: Brightness.light));
  }

  
}