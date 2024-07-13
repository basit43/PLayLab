
import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:play_lab/data/model/global/response_model/response_model.dart';
import 'package:play_lab/data/model/live_tv/live_tv_details_response_model.dart';
import 'package:play_lab/data/repo/live_tv_repo/live_tv_repo.dart';
import 'package:play_lab/view/components/show_custom_snackbar.dart';
import 'package:video_player/video_player.dart';

class LiveTvDetailsController extends GetxController implements GetxService{

  LiveTvRepo repo;
  LiveTvDetailsController({required this.repo});

  bool isLoading=true;

  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  List<RelatedTv>relatedTvList=[];
  String imagePath='';
  Tv tvObject=Tv();

  @override
  void onClose() {
    try{
      videoPlayerController.dispose();
      chewieController.dispose();
    } catch(e){
      print(e.toString());
    }

    videoUrl='';
    isLoading=true;
    super.onClose();
  }

  Future<dynamic> initializePlayer(String s)async{
    videoPlayerController=VideoPlayerController.network(s);
    await videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 4 / 2,
      autoPlay: true,
      isLive: true,
      allowedScreenSleep: false,
      allowFullScreen: true,
      looping: true,
      autoInitialize: true,
      showControls: true ,
    );

    chewieController.addListener(() {
      if (videoPlayerController.value.position ==
          videoPlayerController.value.duration) {}});

    videoUrl=s;
    updateLoadingStatus(false);

  }

  String videoUrl='';

  void initData(int liveTv)async{

      isLoading=true;
      ResponseModel model= await repo.getLiveTvDetails(liveTv);

      if(model.statusCode==200){
        LiveTvDetailsResponseModel responseModel=LiveTvDetailsResponseModel.fromJson(jsonDecode(model.responseJson));
        if(responseModel.status=='success' && responseModel.data?.tv !=null){
          tvObject=responseModel.data!.tv!;
          imagePath=responseModel.data?.imagePath??'';
          if(responseModel.data?.relatedTv !=null && responseModel.data!.relatedTv !=[]){
            relatedTvList.clear();
            relatedTvList.addAll(responseModel.data!.relatedTv!);
          }
          await initializePlayer(responseModel.data?.tv?.url??'');
          updateLoadingStatus(false);
        }else{
          CustomSnackbar.showCustomSnackbar(errorList: [responseModel.message?.error??''], msg: [], isError: true);
          updateLoadingStatus(false);
        }
      }else{
        CustomSnackbar.showCustomSnackbar(errorList: [model.message], msg: [], isError: true);
      }

  }

  updateLoadingStatus(bool status){
    isLoading=status;
    update();
  }


  void clearAllData() {
    try{
      isLoading=true;
      videoUrl='';
      relatedTvList.clear();
      videoPlayerController.dispose();
      chewieController.dispose();
    }catch(e){
      e.printInfo();
    }

  }

}