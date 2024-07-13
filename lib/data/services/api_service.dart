
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:play_lab/core/helper/date_converter.dart';
import 'package:play_lab/shared_preference_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/method.dart';
import '../../core/helper/shared_pref_helper.dart';
import '../../core/route/route.dart';
import '../../core/utils/url_container.dart';
import '../model/authorization/authorization_response_model.dart';
import '../model/general_setting/general_settings_response_model.dart';
import '../model/global/response_model/response_model.dart';


class ApiClient extends GetxService{

  SharedPreferences sharedPreferences;
  ApiClient({required this.sharedPreferences});

  // String? accessToken = MySharedPrefClass.preferences?.getString('token');

  Future<ResponseModel> request(
      String uri, String method, Map<String, dynamic>? params,{bool passHeader=false,bool isOnlyAcceptType=false,}) async {
    print("AR");
    Uri url=Uri.parse(uri);
    http.Response response;
    String? accessToken = MySharedPrefClass.preferences?.getString('token');

    print("AccessToken $accessToken");

    try {
      if (method == Method.postMethod) {
        if(passHeader){
          initToken();
          if(isOnlyAcceptType){
            response = await http.post(url, body: params,headers: {
              'Content-Type': 'application/json',
              "Accept": "application/json",
            });
          }else{
            response = await http.post(url, body: params,headers: {
              "Accept": "application/json",
              "Authorization": "$tokenType $accessToken"
            });
          }

        }else{
          response = await http.post(url, body: params
          );
        }

      }
       else if (method == Method.postMethod) {
        if(passHeader){
          initToken();
          response = await http.post(url, body: params,headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            "Authorization": "$tokenType $accessToken"
          });
        }else{
          response = await http.post(url, body: params
          );
        }

      }
      else if (method == Method.deleteMethod) {
        response = await http.delete(url);
      } else if (method == Method.updateMethod) {
        response = await http.patch(url);
      } else {
        if(passHeader){
          // initToken();
          response = await http.get(
              url,headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            "Authorization": "$tokenType $accessToken"
          });
        }else{
          response = await http.get(
            url,
          );
        }
      }

      print(response.body);
      print(url.toString());
      print(response.statusCode);
      print(params.toString());

      if (response.statusCode == 200) {

        try{
          AuthorizationResponseModel model=AuthorizationResponseModel.fromJson(jsonDecode(response.body));
          if(model.remark=='profile_incomplete'){
            Get.toNamed(RouteHelper.profileComplete);
          }
        }catch(e){
          e.printInfo();
        }
        return ResponseModel(true, 'Success', 200, response.body);
      }
      else if (response.statusCode == 401) {
        return ResponseModel(false, 'Not Subscribed', 401, response.body);
      } else if (response.statusCode == 500) {
        return ResponseModel(false, 'Server Error', 500, response.body);
      } else {
        return ResponseModel(false, 'Something Wrong', 499, response.body);
      }
    } on SocketException catch(e) {
      return ResponseModel(false, 'No Internet Connection', 503, '');
    } on FormatException {
      return ResponseModel(false, 'Bad Response Format!', 400, '');
    }  catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return ResponseModel(false, 'Something Went Wrong', 499, '');
    }
  }

  String token='';
  String tokenType='';
  String? accessToken = MySharedPrefClass.preferences?.getString('token');

  initToken() {
    if (sharedPreferences.containsKey(accessToken.toString())) {
      String? t =
      MySharedPrefClass.preferences!.getString('token');
      String? tType =
      sharedPreferences.getString(SharedPreferenceHelper.accessTokenType);
      token = t ?? '';
      tokenType = tType ?? 'Bearer';
    } else {
      token = '';
      tokenType = 'Bearer';
    }
  }



  String getCurrencyOrUsername({bool isCurrency = true,bool isSymbol = false}){

    if(isCurrency){
      String pre= sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey)??'';
      GeneralSettingsResponseModel model = GeneralSettingsResponseModel.fromJson(jsonDecode(pre));
      String currency = isSymbol? model.data?.generalSetting?.curSym??'' : model.data?.generalSetting?.curText??'';
      return currency;
    } else{
      String username = sharedPreferences.getString(SharedPreferenceHelper.userNameKey)??'';
      return username;
    }

  }




  bool isPaidUser(){
    String expDate = sharedPreferences.getString(SharedPreferenceHelper.expiredDate)??'';
    if(expDate.isEmpty){
      return false;
    } else{
      bool isSubscriptionEnd = DateConverter.isDateOver(expDate);
      return isSubscriptionEnd?false:true;
    }
  }


  void storeExpiredDate(String expDate)async{
    await sharedPreferences.setString(SharedPreferenceHelper.expiredDate,expDate);
  }

  bool getPasswordStrengthStatus(){
    String pre= sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey)??'';
    GeneralSettingsResponseModel model = GeneralSettingsResponseModel.fromJson(jsonDecode(pre));
    bool checkPasswordStrength = model.data?.generalSetting?.securePassword.toString() == '0' ? false : true;
    return checkPasswordStrength;
  }

  bool isFacebookAuthEnable (){
    String pre= sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey)??'';
    GeneralSettingsResponseModel model = GeneralSettingsResponseModel.fromJson(jsonDecode(pre));
    bool isFacebookAuthEnable = model.data?.generalSetting?.socialiteCredentials?.facebook?.status.toString() == '0' ? false : true;
    return isFacebookAuthEnable;
  }

  bool isGmailAuthEnable (){
    String pre= sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey)??'';
    GeneralSettingsResponseModel model = GeneralSettingsResponseModel.fromJson(jsonDecode(pre));
    bool isGmailAuthEnable = model.data?.generalSetting?.socialiteCredentials?.google?.status.toString() == '0' ? false : true;
    return isGmailAuthEnable;
  }

  bool isShowAdmobAds(){
    initToken();
    String pre= sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey)??'';
    GeneralSettingsResponseModel model = GeneralSettingsResponseModel.fromJson(jsonDecode(pre));
    bool showAds = model.data?.generalSetting?.adShowMobile.toString() == '0' ? false : true;
    if(!showAds){
      return false;
    }
    // String  token =  sharedPreferences.getString(SharedPreferenceHelper.accessTokenKey)??'';
    String? token = MySharedPrefClass.preferences?.getString('token');
    if(token!.isEmpty){
      return true;
    } else{
      bool isShowAdsToSubscriber = model.data?.generalSetting?.videoAdSubscriptionUser.toString() == '0' ? false : true;
      return isShowAdsToSubscriber;
    }

  }

  String getTemplateName (){
    String pre= sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey)??'';
    GeneralSettingsResponseModel model = GeneralSettingsResponseModel.fromJson(jsonDecode(pre));
    String templateName = model.data?.generalSetting?.activeTemplate??'';
    return templateName;
  }

  storeGeneralSetting(GeneralSettingsResponseModel model){
    String json=jsonEncode(model.toJson());
    sharedPreferences.setString(SharedPreferenceHelper.generalSettingKey, json);
    getGSData();
  }

  GeneralSettingsResponseModel getGSData(){
    String pre = sharedPreferences.getString(SharedPreferenceHelper.generalSettingKey)??'';
    GeneralSettingsResponseModel model = GeneralSettingsResponseModel.fromJson(jsonDecode(pre));
    return model;
  }




}