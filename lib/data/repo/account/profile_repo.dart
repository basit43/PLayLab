import 'dart:convert';
import 'package:play_lab/constants/my_strings.dart';
import 'package:http/http.dart' as http;
import 'package:play_lab/shared_preference_class.dart';
import '../../../constants/method.dart';
import '../../../core/utils/url_container.dart';
import '../../../view/components/show_custom_snackbar.dart';
import '../../model/account/profile_response_model.dart';
import '../../model/account/user_post_model/user_post_model.dart';
import '../../model/global/common_api_response_model.dart';
import '../../model/global/response_model/response_model.dart';
import '../../services/api_service.dart';

class ProfileRepo {
  ApiClient apiClient;

  ProfileRepo({required this.apiClient});

  Future<bool> updateProfile(UserPostModel m, String callFrom) async {
    Map<String, dynamic> map = {
      'firstname': m.firstname,
      'lastname': m.lastName,
      'address': m.address,
      'zip': m.zip,
      'state': m.state,
      'city': m.city,
    };

    String url =
        '${UrlContainer.baseUrl}${callFrom == 'profile' ? UrlContainer.updateProfileEndPoint : UrlContainer.profileCompleteEndPoint}';
    ResponseModel responseModel =
        await apiClient.request(url, Method.postMethod, map, passHeader: true);
    if (responseModel.statusCode == 200) {
      CommonApiResponseModel model = CommonApiResponseModel.fromJson(responseModel.responseJson);
      if (model.status == 'success') {

        CustomSnackbar.showCustomSnackbar(errorList: [], msg: [

          model.message?.success ?? MyStrings.profileUpdatedSuccessfully
        ], isError: false);
        return true;
      } else {
        CustomSnackbar.showCustomSnackbar(errorList: [
          model.message?.error ?? MyStrings.failedToUpdateProfile
        ], msg: [], isError: true);
        return true;
      }
    } else {
      CustomSnackbar.showCustomSnackbar(
          errorList: [responseModel.message], msg: [], isError: true);
      return false;
    }
  }

  ProfileResponseModel? model;


  Future<ProfileResponseModel> loadProfileInfo() async {
    String? accessToken = MySharedPrefClass.preferences?.getString('token');
    String url = '${UrlContainer.baseUrl}${UrlContainer.getProfileEndPoint}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        //print("Response Body: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.isNotEmpty && jsonResponse['status'] == 'success') {
          return ProfileResponseModel.fromJson(jsonResponse);
        } else {
          // If the response is empty or status is not 'success', return an empty model
          return ProfileResponseModel();
        }
      } else {
        // If the status code is not 200, return an empty model
        return ProfileResponseModel();
      }
    } catch (e) {
      // Handle any errors occurred during the HTTP request
      print("Error fetching profile data: $e");
      return ProfileResponseModel();
    }
  }
}
