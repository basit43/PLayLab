import 'package:flutter/material.dart';

import '../../core/utils/my_images.dart';

class AuthImageWidget extends StatelessWidget {
  const AuthImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset(
          MyImages.splashLogo,
      height: MediaQuery.of(context).size.height * .07,
      width: MediaQuery.of(context).size.width * .6,
      fit: BoxFit.fill,
    ));
  }
}
