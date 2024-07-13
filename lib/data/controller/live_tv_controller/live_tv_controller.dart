
import 'dart:convert';

import 'package:get/get.dart';
import 'package:play_lab/data/repo/live_tv_repo/live_tv_repo.dart';

import '../../model/global/response_model/response_model.dart';
import '../../model/live_tv/live_tv_response_model.dart';

class LiveTvController extends GetxController implements GetxService{

  LiveTvRepo repo;
  LiveTvController({required this.repo});


  bool isLoading=true;
  List<MainTelevisionModel>televisionList=[];
  String televisionImagePath='';
  int page = 0;
  String? nextPageUrl;

  void getLiveTv()async{
    clearAllData();
    page = 1;
    updateLoadingStatus(true);
    ResponseModel model = await repo.getLiveTv(page);
    if(model.statusCode==200){
      LiveTvResponseModel televisionModel=LiveTvResponseModel.fromJson(jsonDecode(model.responseJson));
      nextPageUrl = televisionModel.data?.televisions?.nextPageUrl??'';
      if(televisionModel.data!=null) {
        if(televisionModel.data?.televisions?.data != null && televisionModel.data!.televisions!.data!.isNotEmpty){
          televisionList.clear();
          televisionList.addAll(televisionModel.data!.televisions!.data!);
          televisionImagePath = televisionModel.data?.imagePath??'';
        }
        updateLoadingStatus(false);
      }
    }else{
      updateLoadingStatus(false);
    }
  }

  void getPaginateTV()async{
    page = page+1;
    ResponseModel model = await repo.getLiveTv(page);
    if(model.statusCode==200){
      LiveTvResponseModel televisionModel=LiveTvResponseModel.fromJson(jsonDecode(model.responseJson));
      nextPageUrl = televisionModel.data?.televisions?.nextPageUrl??'';
      if(televisionModel.data!=null) {
        if(televisionModel.data?.televisions?.data != null && televisionModel.data!.televisions!.data!.isNotEmpty){
          televisionList.addAll(televisionModel.data!.televisions!.data!);
          televisionImagePath = televisionModel.data?.imagePath??'';
        }
      }
    }
  }

  bool hasNext() {
    return nextPageUrl != null  && nextPageUrl!.isNotEmpty && nextPageUrl != 'null'? true : false;
  }

  void clearAllData(){
    page=0;
    isLoading=true;
    nextPageUrl=null;
    televisionList.clear();
  }

  void updateLoadingStatus(bool status){
    isLoading=status;
    update();
  }

}