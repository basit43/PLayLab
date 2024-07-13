import 'dart:convert';

import 'package:play_lab/constants/method.dart';
import 'package:play_lab/core/helper/shared_pref_helper.dart';
import 'package:play_lab/core/utils/url_container.dart';
import 'package:play_lab/data/model/authorization/authorization_response_model.dart';
import 'package:play_lab/data/model/global/response_model/response_model.dart';
import 'package:play_lab/data/services/api_service.dart';
import 'package:play_lab/shared_preference_class.dart';

class MovieDetailsRepo{

  ApiClient apiClient;

  MovieDetailsRepo({required this.apiClient});

  Future<dynamic>getWatchVideoData(int itemId,{int episodeId=-1})async{
    print("ItemK $itemId");

    late ResponseModel response;
    // String token=apiClient.sharedPreferences.getString(SharedPreferenceHelper.accessTokenKey)??'';
    String? token = MySharedPrefClass.preferences?.getString('token');
    print("Token $token");
    String url='';
    if(episodeId==-1 ||episodeId == 0){
      url = '${UrlContainer.baseUrl}${token == null?UrlContainer.watchVideoEndPoint:UrlContainer.watchVideoPaidEndPoint}=$itemId';
    }else{
      url = '${UrlContainer.baseUrl}${token == null?UrlContainer.watchVideoEndPoint:UrlContainer.watchVideoPaidEndPoint}=$itemId&episode_id=$episodeId';
    }
    if(token == null){
      response = await apiClient.request(url, Method.getMethod, null);
    }else{
      response = await apiClient.request(url, Method.getMethod, null,passHeader: true);
    }
    return response;
  }

  Future<dynamic>getPlayVideoData(int itemId,{int episodeId=-1})async{

    // String token=apiClient.sharedPreferences.getString(SharedPreferenceHelper.accessTokenKey)??'';
    String? token = MySharedPrefClass.preferences?.getString('token');
    late ResponseModel response;

    //for episode we should send episode id on the other scenario we don't need to send episode id

   String url='';
    if(token == null){
     if(episodeId==-1){
        url='${UrlContainer.baseUrl}${UrlContainer.playVideoEndPoint}=$itemId';
      }else{
        url='${UrlContainer.baseUrl}${UrlContainer.playVideoEndPoint}=$itemId&episode_id=$episodeId';
      }
      response=await apiClient.request(url, Method.getMethod, null);
    }else{
      if(episodeId==-1){
        url='${UrlContainer.baseUrl}${UrlContainer.playVideoPaidEndPoint}=$itemId';
      }else{
        url='${UrlContainer.baseUrl}${UrlContainer.playVideoPaidEndPoint}=$itemId&episode_id=$episodeId';
      }
      response = await apiClient.request(url, Method.getMethod,null,passHeader: true );
    }

    return response;
  }

  Future<dynamic>checkWishlist(int itemId,{int episodeId=-1})async{

    late ResponseModel response;
    String url='${UrlContainer.baseUrl}${UrlContainer.checkWishlistEndpoint}${episodeId<1?'item_id=${itemId.toString()}':'episode_id=${episodeId.toString()}'}';
    response=await apiClient.request(url, Method.getMethod,null,passHeader: true );
    AuthorizationResponseModel model=AuthorizationResponseModel.fromJson(jsonDecode(response.responseJson));
    return model.remark=='true'?true:false;

  }

  Future<dynamic>addInWishList(int itemId,{int episodeId=-1})async{
    late ResponseModel response;
    String url='';
    if(episodeId==-1){
      url='${UrlContainer.baseUrl}${UrlContainer.addInWishlistEndPoint}=$itemId';
    }else{
      url='${UrlContainer.baseUrl}${UrlContainer.addInWishlistEndPoint}=$itemId&episode_id=$episodeId';
    }
    response=await apiClient.request(url, Method.postMethod, null,passHeader: true);
    return response;
  }


}