import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/route/route.dart';
import '../../../../../../core/utils/my_color.dart';
import '../../.././../../../core/utils/dimensions.dart';
import '../../../../../../core/utils/styles.dart';
import '../../../../../../data/controller/category/category_controller/category_controller.dart';
import '../../shimmer/category_shimmer.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
        builder: (controller) => controller.isLoading
            ? const SizedBox(height: 50, child: CategoryShimmer())
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.only(left: Dimensions.homePageLeftMargin),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      controller.categoryList.length,
                      (index) => InkWell(
                            onTap: () {
                              Get.toNamed(RouteHelper.subCategoryScreen,
                                  arguments: [
                                    controller.categoryList[index].id,
                                    controller.categoryList[index].name ?? ''
                                  ]);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 15),
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.cornerRadius),
                                // color: MyColor.t4,
                                // border: Border.all(color: Colors.white30,width: 1),
                              ),
                              child: Text(
                                controller.categoryList[index].name?.tr ?? '',
                                style:
                                    mulishSemiBold.copyWith(color: MyColor.t2),
                              ),
                            ),
                          )),
                ),
              ));
  }
}

class HomeCategoryWidget extends StatelessWidget {
  HomeCategoryWidget({Key? key}) : super(key: key);

  List<String> homeCategoryList = [
    "Recently Added",
    "Featured Items",
    "Out Free Zone",
    "Latest Trailer",
    "Latest Series",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: Dimensions.homePageLeftMargin),
      child: Row(
        children: List.generate(homeCategoryList.length, (index) {
          final categoryName = homeCategoryList[index];
          return InkWell(
            onTap: () {
              switch (index) {
                case 0:
                  Get.toNamed(RouteHelper.recentlyAddedScreen);
                  break;
                case 1:
                  Get.toNamed(RouteHelper.featuredMovieScreen);
                  break;
                case 2:
                  Get.toNamed(RouteHelper.outFreeZoneScreen);
                  break;
                case 3:
                  Get.toNamed(RouteHelper.latestTrailerScreen);
                  break;
                case 4:
                  Get.toNamed(RouteHelper.latestSeriesScreen);
                  break;
                default:
                  // Handle default case or do nothing
                  break;
              }
            },
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.cornerRadius),
                color: MyColor.t4,
                // border: Border.all(color: Colors.white30,width: 1),
              ),
              child: Text(
                categoryName,
                style: mulishSemiBold.copyWith(color: MyColor.t2),
              ),
            ),
          );
        }),
      ),
    );
  }
}



