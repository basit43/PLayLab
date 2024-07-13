import 'package:play_lab/view/screens/all_live_tv/widget/all_live_tv_shimmer/all_live_tv_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_lab/core/route/route.dart';
import 'package:play_lab/core/utils/my_color.dart';
import 'package:play_lab/data/controller/live_tv_controller/live_tv_controller.dart';
import 'package:play_lab/data/repo/live_tv_repo/live_tv_repo.dart';
import 'package:play_lab/data/services/api_service.dart';
import 'package:play_lab/view/components/app_bar/custom_appbar.dart';
import 'package:play_lab/view/screens/all_live_tv/widget/live_tv_grid_item/live_tv_grid_item.dart';

import '../../../constants/my_strings.dart';
import '../../../core/utils/url_container.dart';

class AllLiveTvScreen extends StatefulWidget {
  const AllLiveTvScreen({Key? key}) : super(key: key);

  @override
  State<AllLiveTvScreen> createState() => _AllLiveTvScreenState();
}

class _AllLiveTvScreenState extends State<AllLiveTvScreen> {


  final ScrollController _controller = ScrollController();


  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      if (Get.find<LiveTvController>().hasNext()) {
        Get.find<LiveTvController>().getPaginateTV();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LiveTvRepo(apiClient: Get.find()));
    final liveTvController = Get.put(LiveTvController(repo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      liveTvController.getLiveTv();
      _controller.addListener(_scrollListener);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveTvController>(
     builder: (controller) =>Scaffold(
     backgroundColor: MyColor.secondaryColor,
     appBar: const CustomAppBar(title: MyStrings.allTV,),
     body: controller.isLoading ? const AllLiveTvShimmer() : Padding(
     padding: const EdgeInsets.only(right: 10),
       child: GridView.builder(
       itemCount: controller.televisionList.length+1,
       controller: _controller,
       gridDelegate:
       const SliverGridDelegateWithFixedCrossAxisCount(
       mainAxisSpacing: 10,
       crossAxisCount: 4,
       childAspectRatio: 1),
       itemBuilder: (context, index){

        if(controller.televisionList.length==index){
        return controller.hasNext()? const SizedBox(
          height: 30,
          width: 30,
          child: Center(child: CircularProgressIndicator(color: MyColor.primaryColor,))):const SizedBox.shrink();
        }
        return LiveTvGridItem(
          liveTvName: controller.televisionList[index].title?.tr??'',
          imageUrl: '${UrlContainer.baseUrl}${controller.televisionImagePath}/${controller.televisionList[index].image}',
          press: () {
            Get.toNamed(RouteHelper.liveTvDetailsScreen,arguments: controller.televisionList[index].id);
         });}
        ))));
    }
    }
