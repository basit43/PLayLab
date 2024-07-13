

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:play_lab/constants/method.dart';
import 'package:play_lab/data/services/api_service.dart';

import '../../../core/helper/shared_pref_helper.dart';
import '../../../core/utils/url_container.dart';
import '../../../view/components/show_custom_snackbar.dart';
import '../../model/auth/registration_response_model.dart';
import '../../model/auth/sign_up_model/sign_up_model.dart';
import '../../model/global/response_model/response_model.dart';


class SignupRepo {
  ApiClient apiClient;
  SignupRepo({required this.apiClient});

  Future<RegistrationResponseModel> registerUser(SignUpModel model) async {
    final map = modelToMap(model);
    String url ='${UrlContainer.baseUrl}${UrlContainer.registrationEndPoint}';
    //print(url.toString());
    final res=await apiClient.request(url, Method.postMethod, map, isOnlyAcceptType: true);
    final json = jsonDecode(res.responseJson);
    RegistrationResponseModel responseModel = RegistrationResponseModel.fromJson(json);
   return responseModel;
  }

  Map<String, dynamic> modelToMap(SignUpModel model) {

    Map<String, dynamic> bodyFields = {
      'mobile':model.mobile,
      'email': model.email,
      'agree': model.agree.toString(),
      'username': model.username,
      // 'password': model.password,
      // 'password_confirmation':model.password,//password and confirm password check from front end panel
      'country_code': model.countryCode, //model.country_code,
      'country': model.country, //model.country,
      "mobile_code": model.mobileCode,
    };

    return bodyFields;
  }

  Future<bool> sendUserToken() async {
    String deviceToken;
    if (apiClient.sharedPreferences.containsKey(SharedPreferenceHelper.fcmDeviceKey)) {
      deviceToken = apiClient.sharedPreferences.getString(SharedPreferenceHelper.fcmDeviceKey) ?? '';
    } else {
      deviceToken = '';
    }
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    bool success = false;
    if (deviceToken.isEmpty) {
      firebaseMessaging.getToken().then((fcmDeviceToken) async {
        success = await sendUpdatedToken(fcmDeviceToken ?? '');
      });
    } else {
      firebaseMessaging.onTokenRefresh.listen((fcmDeviceToken) async {
        if (deviceToken == fcmDeviceToken) {
          success = true;
        } else {
          apiClient.sharedPreferences.setString(SharedPreferenceHelper.fcmDeviceKey, fcmDeviceToken);
          success = await sendUpdatedToken(fcmDeviceToken);
        }
      });
    }
    return success;
  }

  Future<ResponseModel> socialLogin(bool isGmail,String token,String email,String name,String id) async{
    Map<String, String> map = {'provider': isGmail?'google':'facebook',
      'access_token': token,
      'email': email,
      'id': id,
      'name':name
    };
    String url = '${UrlContainer.baseUrl}${UrlContainer.socialLoginEndPoint}';
    ResponseModel model = await apiClient.request(url, Method.postMethod, map,passHeader: false);
    return model;
  }



  Future<bool> sendUpdatedToken(String deviceToken) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.deviceTokenEndPoint}';
    Map<String, String> map = deviceTokenMap(deviceToken);
    await apiClient.request(url, Method.postMethod, map, passHeader: true);
    return true;
  }

  Map<String, String> deviceTokenMap(String deviceToken) {
    Map<String, String> map = {'token': deviceToken.toString()};
    return map;
  }

}