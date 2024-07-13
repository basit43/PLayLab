import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/route/route.dart';
import '../../../../../../core/utils/dimensions.dart';
import '../../../../../../core/utils/my_color.dart';
import '../../../../../../core/utils/styles.dart';
import '../../../../../../core/utils/url_container.dart';
import '../../../../../../data/controller/home/home_controller.dart';
import '../../shimmer/portrait_movie_shimmer.dart';
import '../custom_network_image/custom_network_image.dart';

class LatestTrailerWidget extends StatefulWidget {
  const LatestTrailerWidget({Key? key}) : super(key: key);

  @override
  State<LatestTrailerWidget> createState() => _LatestTrailerWidgetState();
}

class _LatestTrailerWidgetState extends State<LatestTrailerWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller)=>
        Padding(
          padding: const EdgeInsets.only(left: Dimensions.homePageLeftMargin, top: 50.0),
          child: controller.trailerMovieLoading?const SizedBox(height:180,child:  PortraitShimmer()):SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children:List.generate(controller.trailerMovieList.length, (index) => GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.movieDetailsScreen,arguments: [controller.trailerMovieList[index].id,-1]);
                  },
                  child: Container(
                    width: 115,
                    margin: const EdgeInsets.only(right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CustomNetworkImage(
                            imageUrl: '${UrlContainer.baseUrl}${controller.trailerImagePath}/${controller.trailerMovieList[index].image?.portrait}',
                            width: 105,
                            height: 160,
                            boxFit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: Dimensions.spaceBetweenTextAndImage,
                        ),
                        Text(controller.trailerMovieList[index].title?.tr??'',style:  mulishSemiBold.copyWith(
                            color: MyColor.colorWhite,
                            fontSize: Dimensions.fontSmall,
                            overflow: TextOverflow.ellipsis),),
                      ],
                    ),
                  ),
                ))
            ),
          ),
        ));
  }
}
