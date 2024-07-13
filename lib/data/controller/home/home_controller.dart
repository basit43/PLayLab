
 import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:play_lab/constants/my_strings.dart';
import 'package:play_lab/core/utils/url_container.dart';
import 'package:play_lab/data/model/global/response_model/response_model.dart';
import 'package:play_lab/data/model/home/enum/enum.dart';
import 'package:play_lab/data/model/home/featured_movie/featured_movie_response_model.dart';
import 'package:play_lab/data/model/home/latest_series/lateast_series_response_model.dart';
import 'package:play_lab/data/model/home/pop_up_ads/Pop_up_ads_model.dart';
import 'package:play_lab/data/model/home/recently_added/recently_added_response_model.dart';
import 'package:play_lab/data/model/home/single_banner/single_banner_response_model.dart';
import 'package:play_lab/data/model/home/slider/slider_model.dart';
import 'package:play_lab/data/model/home/trailer_movie/trailer_movie_response_model.dart';
import 'package:play_lab/data/model/live_tv/live_tv_response_model.dart';
import 'package:play_lab/data/repo/home_repo/home_repo.dart';
import 'package:play_lab/view/components/show_custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../view/screens/bottom_nav_pages/home/widget/pop_up_widget/pop_up_widget.dart';
import '../../model/home/free_zone/free_zone_response_model.dart' as free_zone;

class HomeController extends GetxController {

  HomeRepo homeRepo;
  HomeController({required this.homeRepo});



 TextEditingController searchController=TextEditingController();


  String sliderImagePath='';
  List<Sliders>sliderList=[
  ];

  List<MainTelevisionModel>televisionList=[];
  String televisionImagePath='';

  List<Recent>recentlyAddedList=[];
  String recentlyAddedImagePath='';

  List<Latest>latestSeriesList=[];
  String latestSeriesImagePath='';


  List<Single> singleBannerList=[];
  String singleBannerImagePath='';

  List<Trailer>trailerMovieList=[];
  String trailerImagePath='';

  List<free_zone.Data>freeZoneList=[];
  String freeZoneImagePath='';

  List<Featured>featuredMovieList=[];
  String featuredMovieImagePath='';

 void searchData(String value){

 }

 bool featuredMovieLoading=true;
 bool freeZoneMovieLoading=true;
 bool latestSeriesMovieLoading=true;
 bool liveTvLoading=true;
 bool recentMovieLoading=true;
 bool singleBannerImageLoading=true;
 bool trailerMovieLoading=true;
 bool sliderLoading=true;


 Future<void>getAllData()async{
   print("Get All Data");
         getSlider();
         getLiveTv();
         getRecentMovie();
         getLatestSeriesMovie();
         getSingleBanner();
         getTrailerMovie();
         getFreeZoneMovie();
         getFeaturedMovie();
         getPopUpAds();
 }


 String popAdsUrl = '';
 String popAdsClickUrl = '';
 void getPopUpAds() async {

   popAdsUrl = '';
   popAdsClickUrl = '';

   ResponseModel response = await homeRepo.getPopUpAds();
   if(response.statusCode == 200){
      PopUpAdsModel popUpAdsModel = PopUpAdsModel.fromJson(jsonDecode(response.responseJson));
      if(popUpAdsModel.status?.toLowerCase() == MyStrings.success.toLowerCase()){
        String image = popUpAdsModel.data?.advertise?.content?.image ?? '';
        String imagePath = popUpAdsModel.data?.imagePath ?? '';
        if(image.isNotEmpty){
          popAdsUrl = '${UrlContainer.baseUrl}$imagePath/$image';
          popAdsClickUrl = popUpAdsModel.data?.advertise?.content?.link ?? '';
          await Future.delayed(const Duration(seconds: 5));
          PopupBanner(
            context: Get.context!,
            useDots: false,
            images: [
              popAdsUrl,
            ],
            onClick: (index) async{
              await launchUrl(
                Uri.parse(popAdsClickUrl),
                mode: LaunchMode.platformDefault,
              );
            },
          ).show();
        }
      }
   }

 }

 void getFeaturedMovie()async{

   updateLoadingStatus(LoadingEnum.featureMovieLoading, true);
   ResponseModel model=await homeRepo.getFeaturedMovie();
   if(model.statusCode==200){
     FeaturedMovieResponseModel featuredMovieModel= FeaturedMovieResponseModel.fromJson(jsonDecode(model.responseJson));
     if(featuredMovieModel.data!=null && featuredMovieModel.data?.featured !=null && featuredMovieModel.data!.featured!.isNotEmpty){
       featuredMovieList.clear();
       featuredMovieList.addAll(featuredMovieModel.data!.featured!);
       featuredMovieImagePath=featuredMovieModel.data?.portraitPath??'';
     }
     updateLoadingStatus(LoadingEnum.featureMovieLoading,false);
   }else{
     updateLoadingStatus(LoadingEnum.featureMovieLoading, false);
   }
 }

 void getFreeZoneMovie()async{
   updateLoadingStatus(LoadingEnum.freeZoneMovieLoading, true);
   ResponseModel model=await homeRepo.getFreeZoneMovie(1);
   if(model.statusCode==200){
     free_zone.FreeZoneResponseModel freeZoneModel= free_zone.FreeZoneResponseModel.fromJson(jsonDecode(model.responseJson));
      if(freeZoneModel.data!=null && freeZoneModel.data?.freeZone?.data !=null && freeZoneModel.data!.freeZone!.data!.isNotEmpty){
        freeZoneList.clear();
        freeZoneList.addAll(freeZoneModel.data!.freeZone!.data!);
        freeZoneImagePath=freeZoneModel.data?.portraitPath??'';
      }
      updateLoadingStatus(LoadingEnum.freeZoneMovieLoading,false);
   }else{
      updateLoadingStatus(LoadingEnum.freeZoneMovieLoading, false);
   }
 }

 void getLatestSeriesMovie()async{
   updateLoadingStatus(LoadingEnum.latestSeriesMovieLoading, true);
   ResponseModel model=await homeRepo.getLatestSeries();
   if(model.statusCode==200){
       LatestSeriesResponseModel latestSeries=LatestSeriesResponseModel.fromJson(jsonDecode(model.responseJson));

       if(latestSeries.data!=null && latestSeries.data?.latest !=null && latestSeries.data!.latest!.isNotEmpty){
         latestSeriesList.clear();
         latestSeriesList.addAll(latestSeries.data!.latest!);
         latestSeriesImagePath=latestSeries.data?.landscapePath??'';
       }

       updateLoadingStatus(LoadingEnum.latestSeriesMovieLoading, false);

   }else{
     CustomSnackbar.showCustomSnackbar(errorList: [model.message], msg: [], isError: false);
     updateLoadingStatus(LoadingEnum.latestSeriesMovieLoading, false);
   }

 }

 void getLiveTv()async{

   updateLoadingStatus(LoadingEnum.liveTvLoading, true);

   ResponseModel model=await homeRepo.getLiveTv();
   if(model.statusCode==200){
      LiveTvResponseModel televisionModel=LiveTvResponseModel.fromJson(jsonDecode(model.responseJson));
      if(televisionModel.data!=null) {
        if(televisionModel.data?.televisions?.data!=null && televisionModel.data!.televisions!.data!.isNotEmpty){
          televisionList.clear();
          televisionList.addAll(televisionModel.data!.televisions!.data!);
          televisionImagePath=televisionModel.data?.imagePath??'';
        }
        updateLoadingStatus(LoadingEnum.liveTvLoading, false);
      }
   }
   else{
     updateLoadingStatus(LoadingEnum.liveTvLoading, false);
   }
 }

 void getRecentMovie()async{
   updateLoadingStatus(LoadingEnum.recentMovieLoading, true);
   ResponseModel model=await homeRepo.getRecentMovie();
   if(model.statusCode==200){
       RecentlyAddedResponseModel recentModel=RecentlyAddedResponseModel.fromJson(jsonDecode(model.responseJson));
       if(recentModel.data?.recent!=null && recentModel.data!.recent!.isNotEmpty){
         recentlyAddedList.clear();
         recentlyAddedList.addAll(recentModel.data!.recent!);
         recentlyAddedImagePath=recentModel.data?.portraitPath??'';
       }
       updateLoadingStatus(LoadingEnum.recentMovieLoading, false);
   }else{
       CustomSnackbar.showCustomSnackbar(errorList: [(model.message)], msg: [], isError: true);
       updateLoadingStatus(LoadingEnum.recentMovieLoading, false);
   }
 }

 void getSingleBanner()async{
  updateLoadingStatus(LoadingEnum.singleBannerImageLoading, true);
   ResponseModel model=await homeRepo.getSingleBannerImage();
   if(model.statusCode==200){
     SingleBannerResponseModel singleBanner=SingleBannerResponseModel.fromJson(jsonDecode(model.responseJson));
     if(singleBanner.data!=null && singleBanner.data?.single!=null){
       singleBannerList=(singleBanner.data?.single)!;
       singleBannerImagePath=singleBanner.data?.landscapePath??'';
     }
     updateLoadingStatus(LoadingEnum.singleBannerImageLoading, false);
   }else{
     CustomSnackbar.showCustomSnackbar(errorList: [model.message], msg: [], isError:true);
     updateLoadingStatus(LoadingEnum.singleBannerImageLoading, false);
   }
 }

 void getTrailerMovie()async{
  updateLoadingStatus(LoadingEnum.trailerMovieLoading, true);
   ResponseModel model=await homeRepo.getTrailerMovie();
   print("TrailerMovie ${model.statusCode}");
   if(model.statusCode==200){

      TrailerMovieResponseModel trailerModel=TrailerMovieResponseModel.fromJson(jsonDecode(model.responseJson));
      if(trailerModel.data?.trailer !=null && trailerModel.data!.trailer!.isNotEmpty ){
        trailerMovieList.clear();
        trailerMovieList.addAll(trailerModel.data!.trailer!);
        trailerImagePath=trailerModel.data?.portraitPath??'';
      }
      updateLoadingStatus(LoadingEnum.trailerMovieLoading, false);
   }else{

     CustomSnackbar.showCustomSnackbar(errorList: [model.message], msg: [], isError: true);
     updateLoadingStatus(LoadingEnum.trailerMovieLoading, false);

   }
 }

 void getSlider()async{

  updateLoadingStatus(LoadingEnum.sliderLoading, true);
   update();
   ResponseModel model=await homeRepo.getSlider();

   if(model.statusCode==200){
       SliderResponseModel sliderModel=SliderResponseModel.fromJson(jsonDecode(model.responseJson));
       if(sliderModel.data!=null) {
         if(sliderModel.data?.sliders!=null && sliderModel.data!.sliders!.isNotEmpty){
           sliderList.clear();
           sliderList.addAll(sliderModel.data!.sliders!);
           sliderImagePath=sliderModel.data?.path??'';
           print("SliderPath $sliderImagePath");

         }
         updateLoadingStatus(LoadingEnum.sliderLoading, false);
       }
   }else{
    updateLoadingStatus(LoadingEnum.sliderLoading, false);
   }




 }


 void updateLoadingStatus(LoadingEnum loadingEnum,bool status){


     if(loadingEnum==LoadingEnum.featureMovieLoading){
       featuredMovieLoading=status;
       update();
     }

     else if(loadingEnum==LoadingEnum.freeZoneMovieLoading){
       freeZoneMovieLoading=status;
       update();
     }

     else if(loadingEnum==LoadingEnum.latestSeriesMovieLoading){
       latestSeriesMovieLoading=status;
       update();
     }

     else if(loadingEnum==LoadingEnum.liveTvLoading){
       liveTvLoading=status;
       update();
     }

     else if(loadingEnum==LoadingEnum.recentMovieLoading){
       recentMovieLoading=status;
       update();
     }

     else if(loadingEnum==LoadingEnum.singleBannerImageLoading){
       singleBannerImageLoading=status;
       update();
     }

     else if(loadingEnum==LoadingEnum.trailerMovieLoading){
       trailerMovieLoading=status;
       update();
     }

     else if(loadingEnum==LoadingEnum.sliderLoading){
       sliderLoading=status;
       update();
     }

 }

 bool isGuest(){
   // homeRepo.apiClient.initToken();
   String token = homeRepo.apiClient.token;
   if(token.isEmpty) {
      return true;
    }
    return false;
 }


}