import 'package:play_lab/core/utils/url_container.dart';
import 'package:play_lab/data/model/global/response_model/response_model.dart';
import 'package:play_lab/data/services/api_service.dart';

import '../../../constants/method.dart';

class SubscribePlanRepo{

  ApiClient apiClient;
  SubscribePlanRepo({required this.apiClient});

  Future<dynamic>getPlan({required int page})async{
    String url='${UrlContainer.baseUrl}${UrlContainer.getPlanEndPoint}?page=$page';
    final response = await apiClient.request(url, Method.getMethod, null,passHeader: true);
    return response;
  }

  Future<dynamic>buyPlan(int id)async{
    String url='${UrlContainer.baseUrl}${UrlContainer.buyPlanEndPoint}';
    Map<String,dynamic>params={'id':id.toString()};
    ResponseModel  responseModel=await apiClient.request(url, Method.postMethod, params,passHeader: true);
    return responseModel;
  }


}
