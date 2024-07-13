import 'package:flutter/material.dart';

import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';

class RoundedLoadingButton extends StatelessWidget {

  final Color color, textColor;
  final double width;
  final double hPadding;
  final double vPadding;

  const RoundedLoadingButton({
    Key? key,
    this.width=1,
    this.color = MyColor.primaryColor,
    this.textColor = Colors.white,
    this.hPadding = 35,
    this.vPadding = 15
  }):super(key: key) ;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * width,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
          child: ElevatedButton(
            onPressed: (){},
            style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shadowColor: MyColor.transparentColor,
                padding:  EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
                textStyle: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500)),
            child: SizedBox(width:20, height:20, child: CircularProgressIndicator(color: textColor, strokeWidth: 2)),
          )
      ),
    );

  }

}