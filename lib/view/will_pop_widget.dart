import 'package:play_lab/view/components/dialog/exit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class WillPopWidget extends StatelessWidget {

  final Widget child;
  final String nextRoute;

  const WillPopWidget({Key? key,
    required this.child,
    this.nextRoute = ''
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if(nextRoute.isEmpty){
            showExitDialog(context);
            return Future.value(false);
          }else{
            Get.offAndToNamed(nextRoute);
            return Future.value(false);
          }
        },
        child: child);
  }
}
