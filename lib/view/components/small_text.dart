
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../core/utils/my_color.dart';
import '../../core/utils/dimensions.dart';
import '../../core/utils/styles.dart';

import '../../core/utils/dimensions.dart';

class SmallText extends StatelessWidget {

  final String text;
  final TextStyle textStyle;

  const SmallText({
    Key? key,
    required this.text,
    this.textStyle=mulishLight
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Text(text.tr,style: textStyle);
  }
}


