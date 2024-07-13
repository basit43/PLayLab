
import 'dart:convert';

import 'package:play_lab/data/services/api_service.dart';

import 'package:play_lab/constants/my_strings.dart';
import '../../../constants/method.dart';
import '../../../core/helper/shared_pref_helper.dart';
import '../../../core/utils/url_container.dart';
import '../../model/global/response_model/response_model.dart';


class SplashRepo{

  ApiClient apiClient;
  SplashRepo({required this.apiClient});


  Future<dynamic> getOnboardingData() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.onboardingEndPoint}';
    ResponseModel model = await apiClient.request(url, Method.getMethod, null);
    return model;
  }

  Future<dynamic> getLanguage(String languageCode) async {
    try{
      String url='${UrlContainer.baseUrl}${UrlContainer.languageUrl}$languageCode';
      ResponseModel response= await apiClient.request(url,Method.getMethod, null,passHeader: false);
      return response;
    }catch(e){
      return ResponseModel(false, MyStrings.somethingWentWrong, 300, '');
    }

  }




}