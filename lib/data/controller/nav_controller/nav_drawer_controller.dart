import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:play_lab/shared_preference_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/my_strings.dart';
import '../../../core/helper/shared_pref_helper.dart';
import '../../../core/utils/url_container.dart';
import '../../../view/components/show_custom_snackbar.dart';
import '../../model/auth/verification/email_verification_model.dart';

class NavDrawerController extends GetxController implements GetxService {
  SharedPreferences sharedPreferences;

  NavDrawerController({required this.sharedPreferences});

  int notification = 0;
  Future<bool> logout(context) async {
    initToken();

    Uri url = Uri.parse('${UrlContainer.baseUrl}${UrlContainer.userLogoutEndPoint}');

    try {
      final response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "$tokenType $token"
      });

      EmailVerificationModel model = EmailVerificationModel.fromJson(jsonDecode(response.body));
      print("EmailModel ${model.message}");
      print("EmailModel ${model.data}");

      if (model.message?.success != null) {
        CustomSnackbar.showCustomSnackbar(errorList: [], msg: model.message?.success??[MyStrings.logoutSuccessMsg], isError: false);
        sharedPreferences.setString(SharedPreferenceHelper.accessTokenKey, '');
        MySharedPrefClass.logout(context);
        return true;
      } else {
        CustomSnackbar.showCustomSnackbar(errorList: model.message!.error ?? [], msg: [MyStrings.logoutSuccessMsg], isError: true);
        sharedPreferences.setString(SharedPreferenceHelper.accessTokenKey, '');
        return false;
      }
    } catch (e) {
      sharedPreferences.setString(SharedPreferenceHelper.accessTokenKey, '');
      return false;
    }
  }

  Future<bool> deleteUser() async {

    initToken();
    Uri url = Uri.parse('${UrlContainer.baseUrl}${UrlContainer.userDeleteEndPoint}');
    try {

      final response = await http.post(url, headers: {
        "Accept": "application/json",
        "Authorization": "$tokenType $token"
      });

      EmailVerificationModel model = EmailVerificationModel.fromJson(jsonDecode(response.body));

      if (model.message?.success != null) {
       // CustomSnackbar.showCustomSnackbar(errorList: [], msg: model.message?.success??[MyString.deleteSuccessMsg], isError: false);
        sharedPreferences.setString(SharedPreferenceHelper.accessTokenKey, '');
        return true;
      } else {
        //CustomSnackbar.showCustomSnackbar(errorList: model.message!.error ?? [], msg: [MyString.deleteFailMsg], isError: true);
        sharedPreferences.setString(SharedPreferenceHelper.accessTokenKey, '');
        return false;
      }
    } catch (e) {
      sharedPreferences.setString(SharedPreferenceHelper.accessTokenKey, '');
      return false;
    }
  }

  String token = '';
  String tokenType = '';
  initToken() {
    if (sharedPreferences.containsKey(SharedPreferenceHelper.accessTokenKey)) {
      // String? t = sharedPreferences.getString(SharedPreferenceHelper.accessTokenKey);
      String? t = MySharedPrefClass.preferences?.getString('token');
      String? tType = sharedPreferences.getString(SharedPreferenceHelper.accessTokenType);
      token = t ?? '';
      tokenType = tType ?? 'Bearer';
    } else {
      token = '';
      tokenType = 'Bearer';
    }
  }
}
