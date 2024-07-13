import 'dart:convert';
import 'package:get/get.dart';
import 'package:play_lab/constants/constant_helper.dart';
import 'package:play_lab/constants/my_strings.dart';
import 'package:play_lab/core/route/route.dart';
import 'package:play_lab/data/model/subscribe_plan/buy_subscribe_plan_response_model.dart';
import 'package:play_lab/data/model/subscribe_plan/subscribe_plan_response_model.dart';
import 'package:play_lab/data/repo/subscribe_plan_repo/subscribe_plan_repo.dart';
import '../../../core/utils/url_container.dart';
import '../../../shared_preference_class.dart';
import '../../../view/components/show_custom_snackbar.dart';
import '../../model/global/response_model/response_model.dart';
import 'package:http/http.dart' as http;

class SubscribePlanController extends GetxController {
  SubscribePlanRepo repo;

  SubscribePlanController({required this.repo});

  String? nextPageUrl;
  bool isLoading = true;
  bool isBuyPlanClick = false;
  List<Data> planList = [];
  int selectedIndex = -1;
  String portraitImagePath = '';

  String currency='\$';

  int page = 0;

  void fetchInitialPlan() async {
    try {
      String? accessToken = MySharedPrefClass.preferences?.getString('token');
      String url='${UrlContainer.baseUrl}${UrlContainer.getPlanEndPoint}?page=$page';

      updateStatus(true);
      page = 1;

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("Response Body: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if(jsonResponse.isNotEmpty && jsonResponse['status'] == 'success'){
          SubscribePlanResponseModel responseModel = SubscribePlanResponseModel.fromJson(jsonResponse);
          List<Data>? tempPlanList = responseModel.data?.plans?.data;
          nextPageUrl = responseModel.data?.plans?.nextPageUrl;
          portraitImagePath = responseModel.data?.image ?? '';
          if (tempPlanList?.isNotEmpty == true) {
            if (page == 1) planList.clear();
            planList.addAll(tempPlanList!);
          }
          updateStatus(false);
          } else {
          updateStatus(false);
          }
        } else {
        updateStatus(false);
        }
    } catch (e) {
      print("Error fetching profile data: $e");
    } finally {
      updateStatus(false);
    }

    // updateStatus(true);
    // page = 1; //page+1;
    //
    // currency=repo.apiClient.getGSData().data?.generalSetting?.curText??'USD';
    // ResponseModel model = await repo.getPlan(page: page);
    //
    // if (model.statusCode == 200) {
    //   SubscribePlanResponseModel responseModel =
    //       SubscribePlanResponseModel.fromJson(jsonDecode(model.responseJson));
    //   List<Data>? tempPlanList = responseModel.data?.plans?.data;
    //   nextPageUrl = responseModel.data?.plans?.nextPageUrl;
    //   portraitImagePath = responseModel.data?.image ?? '';
    //
    //   if (tempPlanList?.isNotEmpty == true) {
    //      if (page == 1) planList.clear();
    //      planList.addAll(tempPlanList!);
    //   }
    //   updateStatus(false);
    // } else {
    //   updateStatus(false);
    // }
  }

  void fetchNewPlanList() async {
    page = page + 1;
    ResponseModel model = await repo.getPlan(page: page);

    if (model.statusCode == 200) {
      SubscribePlanResponseModel responseModel = SubscribePlanResponseModel.fromJson(jsonDecode(model.responseJson));
      List<Data>? tempPlanList = responseModel.data?.plans?.data;
      nextPageUrl = responseModel.data?.plans?.nextPageUrl;

      if (tempPlanList?.isNotEmpty == true) {
        planList.addAll(tempPlanList!);
      }
      update();
    }
  }

  updateStatus(bool status) {
    isLoading = status;
    update();
  }

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!='null' && nextPageUrl!.isNotEmpty ? true : false;
  }

  void clearAllData() {
    page = 0;
    isLoading = true;
    nextPageUrl = null;
    planList.clear();
  }

  int sIndex=-1;

  void buyPlan(int index) async {
    isBuyPlanClick = true;
    sIndex=index;
    update();
    try{
      String url='${UrlContainer.baseUrl}${UrlContainer.buyPlanEndPoint}';
      String? accessToken = MySharedPrefClass.preferences?.getString('token');
      // Constructing parameters to be sent in the request body
      Map<String, dynamic> params = {'id': planList[index].id?.toInt() ?? 0};

      // Convert parameters to JSON string
      String requestBody = json.encode(params);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      if(response.statusCode == 200){
        print("Response Body: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if(jsonResponse.isNotEmpty && jsonResponse['status'] == 'success'){
          BuySubscribePlanResponseModel bModel = BuySubscribePlanResponseModel.fromJson(jsonResponse);
          if(bModel.status=='success'){
            isBuyPlanClick=false;
            String subId = bModel.data?.subscriptionId??'';
            update();
            Get.toNamed(RouteHelper.depositScreen,arguments: [planList[index].pricing,planList[index].name,subId,planList[index].id.toString()]);
          }else{
            CustomSnackbar.showCustomSnackbar(errorList: [bModel.message?.error.toString() ?? MyStrings.failedToBuySubscriptionPlan], msg:[''], isError: true);
          }
        }
      }else {
        CustomSnackbar.showCustomSnackbar(errorList: [response.body], msg: [], isError: true);
      }

      // ResponseModel response = await repo.buyPlan(planList[index].id?.toInt() ?? 0);
      // if (response.statusCode == 200) {
      //   BuySubscribePlanResponseModel bModel=BuySubscribePlanResponseModel.fromJson(jsonDecode(response.responseJson));
      //   if(bModel.status=='success'){
      //     isBuyPlanClick=false;
      //     String subId = bModel.data?.subscriptionId??'';
      //     update();
      //    Get.toNamed(RouteHelper.depositScreen,arguments: [planList[index].pricing,planList[index].name,subId,planList[index].id.toString()]);
      //   }else{
      //     CustomSnackbar.showCustomSnackbar(errorList: [bModel.message?.error.toString() ?? MyStrings.failedToBuySubscriptionPlan], msg:[''], isError: true);
      //   }
      // } else {
      //   CustomSnackbar.showCustomSnackbar(errorList: [response.message], msg: [], isError: true);
      // }


    }catch(e){
     PrintHelper.printHelper(e.toString());
    }
    isBuyPlanClick = false;
    update();
  }
}
