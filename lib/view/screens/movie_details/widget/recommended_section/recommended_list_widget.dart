import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_lab/constants/my_strings.dart';
import 'package:play_lab/core/utils/dimensions.dart';
import 'package:play_lab/core/utils/my_color.dart';
import 'package:play_lab/core/utils/url_container.dart';
import 'package:play_lab/data/controller/movie_details_controller/movie_details_controller.dart';
import '../../../bottom_nav_pages/home/widget/custom_network_image/custom_network_image.dart';
import 'package:play_lab/view/components/buttons/category_button.dart';
import '../../../bottom_nav_pages/home/shimmer/portrait_movie_shimmer.dart';

class RecommendedListWidget extends StatefulWidget {
  const RecommendedListWidget({Key? key}) : super(key: key);

  @override
  State<RecommendedListWidget> createState() => _RecommendedListWidgetState();
}

class _RecommendedListWidgetState extends State<RecommendedListWidget> {
  @override
  Widget build(BuildContext context) {
    String portraitPath = 'assets/images/item/portrait/';
    return GetBuilder<MovieDetailsController>(
      builder: (controller) => controller.videoDetailsLoading
          ? const SizedBox(height: 180, child: PortraitShimmer())
          : Padding(
              padding:
                  const EdgeInsets.only(left: Dimensions.homePageLeftMargin),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(controller.relatedItemsList.length,
                      (index) {
                    print(
                        "NNN '${UrlContainer.baseUrl}$portraitPath${controller.relatedItemsList[index].image?.portrait ?? ''}'");
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      splashColor: MyColor.primaryColor500,
                      onTap: () {
                        controller.gotoNextPage(
                            controller.relatedItemsList[index].id ?? -1, -1);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CustomNetworkImage(
                                      width: 140,
                                      height: 180,
                                      imageUrl:
                                          '${UrlContainer.baseUrl}$portraitPath${controller.relatedItemsList[index].image?.portrait ?? ''}'),
                                ),
                                controller.relatedItemsList[index].version ==
                                        '0'
                                    ? Positioned(
                                        top: 8,
                                        right: 8,
                                        child: CategoryButton(
                                            text: MyStrings.free.tr,
                                            horizontalPadding: 8,
                                            verticalPadding: 2,
                                            press: () {}))
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
    );
  }
}
