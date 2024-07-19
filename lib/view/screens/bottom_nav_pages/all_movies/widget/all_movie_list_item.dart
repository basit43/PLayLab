import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:play_lab/core/utils/dimensions.dart';
import 'package:play_lab/core/utils/my_color.dart';
import 'package:play_lab/core/utils/url_container.dart';
import 'package:play_lab/data/controller/all_movies_controller/all_movies_controller.dart';
import 'package:play_lab/view/components/dialog/login_dialog.dart';
import 'package:play_lab/view/components/dialog/subscribe_now_dialog.dart';

import '../../../../../core/route/route.dart';
import '../../home/shimmer/grid_shimmer.dart';
import '../../home/widget/custom_network_image/custom_network_image.dart';

class AllMovieListWidget extends StatefulWidget {
  const AllMovieListWidget({Key? key}) : super(key: key);

  @override
  State<AllMovieListWidget> createState() => _AllMovieListWidgetState();
}

class _AllMovieListWidgetState extends State<AllMovieListWidget> {
  final ScrollController _controller = ScrollController();

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      if (Get.find<AllMoviesController>().hasNext()) {
        Get.find<AllMoviesController>().fetchNewMovieList();
      }
    }
  }

  @override
  void initState() {
    Get.put(AllMoviesController(repo: Get.find()));
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Get.find<AllMoviesController>().fetchInitialMovieList();
      _controller.addListener(_scrollListener);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllMoviesController>(
      builder: (controller) => controller.isLoading
          ? GridShimmer()
          : AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.space15,
                  horizontal: Dimensions.space15,
                ),
                itemCount: controller.movieList.length + 1,
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                itemBuilder: (context, index) {
                  if (controller.movieList.length == index) {
                    return controller.hasNext()
                        ? SizedBox(
                            height: 30,
                            width: 30,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: MyColor.primaryColor,
                              ),
                            ),
                          )
                        : SizedBox.shrink();
                  }

                  final movie = controller.movieList[index];

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 1000),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () {
                            bool isFree = movie.version == '0';
                            bool isPaidUser =
                                controller.repo.apiClient.isPaidUser();

                            if (controller.isGuest() && !isFree) {
                              showLoginDialog(context);
                            } else if (!isPaidUser && !isFree) {
                              showSubscribeDialog(context);
                            } else {
                              Get.toNamed(RouteHelper.movieDetailsScreen,
                                  arguments: [
                                    controller.movieList[index].id,
                                    -1
                                  ]);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 15.0),
                            decoration: BoxDecoration(
                              color: MyColor.colorBlack,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CustomNetworkImage(
                                    imageUrl:
                                        '${UrlContainer.baseUrl}${controller.portraitImagePath}${movie.image?.portrait}',
                                    height: 200,
                                    width: 150,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          movie.title?.tr ?? '',
                                          style: const TextStyle(
                                            color: MyColor.colorWhite,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
