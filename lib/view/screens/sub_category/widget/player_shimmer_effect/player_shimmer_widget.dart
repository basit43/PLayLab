import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:play_lab/core/utils/my_color.dart';


class PlayerShimmerWidget extends StatelessWidget {

  final VoidCallback? press;
  final bool fromLiveTv;

  const PlayerShimmerWidget({
    Key? key,
    this.fromLiveTv=true,
    this.press
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Stack(
        children: [
          SafeArea(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: MyColor.shimmerSplashColor,
                height: 200,
                width: MediaQuery.of(context).size.width - 20,
              ),
            ),
          ),
          const Positioned(top:0,bottom:0,left:0,right:0,child: SpinKitFadingCircle(size: 60,color: MyColor.primaryColor,)),
          SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  top: 15,
                ),
                child: GestureDetector(
                    onTap:fromLiveTv? () {
                      Get.back();
                    }:press,
                    child: const Icon(
                      Icons.arrow_back,
                      color: MyColor.colorWhite,
                      size: 20,
                    ))),
          ),
        ],
      ),
    );
  }
}
