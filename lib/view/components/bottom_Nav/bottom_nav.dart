import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:play_lab/constants/my_strings.dart';
import 'package:play_lab/core/utils/my_color.dart';
import 'package:play_lab/core/utils/my_images.dart';

import '../../../core/route/route.dart';

class CustomBottomNav extends StatefulWidget {
  final int currentIndex;

  const CustomBottomNav({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavyBar(
      selectedIndex: widget.currentIndex,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      backgroundColor: MyColor.cardBg,
      onItemSelected: (index) {
        _onTap(index);
      },
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
            icon: SvgPicture.asset(
              MyImages.homeIcon,
              height: 16,
              width: 16,
              color: widget.currentIndex == 0
                  ? MyColor.primaryColor
                  : MyColor.colorWhite,
            ),
            title: Text(MyStrings.home.tr),
            activeColor: MyColor.primaryColor,
            textAlign: TextAlign.center,
            inactiveColor: MyColor.primaryText),
        BottomNavyBarItem(
            icon: SvgPicture.asset(
              MyImages.allMovieIcon,
              height: 16,
              width: 16,
              color: widget.currentIndex == 1
                  ? MyColor.primaryColor
                  : MyColor.colorWhite,
            ),
            title: Text(MyStrings.movie.tr),
            activeColor: MyColor.primaryColor,
            textAlign: TextAlign.center,
            inactiveColor: MyColor.primaryText),
        BottomNavyBarItem(
            icon: SvgPicture.asset(
              MyImages.allTvSeriesIcon,
              height: 16,
              width: 16,
              color: widget.currentIndex == 2
                  ? MyColor.primaryColor
                  : MyColor.colorWhite,
            ),
            title: Text(MyStrings.allEpisodes.tr),
            activeColor: MyColor.primaryColor,
            textAlign: TextAlign.center,
            inactiveColor: MyColor.primaryText),
        BottomNavyBarItem(
            icon: SvgPicture.asset(
              MyImages.menuIcon,
              height: 16,
              width: 16,
              color: widget.currentIndex == 3
                  ? MyColor.primaryColor
                  : MyColor.colorWhite,
            ),
            title: Text(MyStrings.menu.tr),
            activeColor: MyColor.primaryColor,
            textAlign: TextAlign.center,
            inactiveColor: MyColor.primaryText),
      ],
    );
  }

  void _onTap(int index) {
    if (index == 0) {
      if (!(widget.currentIndex == 0)) {
        Get.toNamed(RouteHelper.homeScreen);
      }
    } else if (index == 1) {
      if (!(widget.currentIndex == 1)) {
        Get.toNamed(RouteHelper.allMovieScreen);
      }
    } else if (index == 2) {
      if (!(widget.currentIndex == 2)) {
        Get.toNamed(RouteHelper.allEpisodeScreen);
      }
    } else if (index == 3) {
      Scaffold.of(context).openDrawer();
    }
  }
}
