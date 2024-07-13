
import 'dart:io';

import 'package:play_lab/core/route/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/my_strings.dart';
import '../../../core/helper/shared_pref_helper.dart';
import '../../../core/utils/url_container.dart';
import '../../model/account/profile_response_model.dart';
import '../../model/account/user_post_model/user_post_model.dart';
import '../../repo/account/profile_repo.dart';


class ProfileController extends GetxController implements GetxService {

  ProfileRepo profileRepo;

 ProfileResponseModel model= ProfileResponseModel();

  String imageStaticUrl='';
  String callFrom='';

  ProfileController({required this.profileRepo});

  List<String> errors = [];
  String imageUrl='';
  String? currentPass, password, confirmPass;
  bool isLoading = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode mobileNoFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode stateFocusNode = FocusNode();
  FocusNode zipCodeFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode countryFocusNode = FocusNode();

  File? imageFile;

  addError({required String error}) {
    if (!errors.contains(error)) {
      errors.add(error);
    }
  }

  removeError({required String error}) {
    if (errors.contains(error)) {
      errors.remove(error);
    }
  }


  loadProfileInfo() async {
    isLoading = true;
    update();
    model= await profileRepo.loadProfileInfo();
    print("Model $model");
    print("Model2 ${model.data?.user?.firstname}");
    if(model.data!=null && model.status=='success'){
      print("Model2 ${model.data?.user?.firstname}");
      loadData(model);
      print("Model2 ${model.data?.user?.firstname}");
    }else{
       isLoading=false;
       update();
    }

  }


  updateProfile(String callFrom)async{

    String firstName=firstNameController.text;
    String lastName=lastNameController.text.toString();
    String address=addressController.text.toString();
    String city=cityController.text.toString();
    String zip=zipCodeController.text.toString();
    String state=stateController.text.toString();
    User? user=model.data?.user;

    if(firstName.isNotEmpty && lastName.isNotEmpty){
      isLoading=true;
      update();
      UserPostModel model=UserPostModel(
          firstname: firstName, lastName: lastName, mobile: user?.mobile??'', email: user?.email??'',
          username: user?.username??'', countryCode: user?.countryCode??'', country: user?.address?.country??'', mobileCode: '91',
          image:imageFile, address: address, state: state,
          zip: zip, city: city);
      Get.offAndToNamed(RouteHelper.loginScreen);
        bool b= await profileRepo.updateProfile(model,callFrom);



       if(b){


         if(callFrom.toLowerCase()=='profile_complete'.toLowerCase()){
           Get.offAndToNamed(RouteHelper.homeScreen);
           return;
         }
           await loadProfileInfo();
           callFrom = 'profile';
       }

      isLoading=false;
      update();
    }else{
      if(firstName.isEmpty){
        addError(error: MyStrings.kFirstNameNullError);
      } if(lastName.isEmpty){
        addError(error:MyStrings.kLastNameNullError);
      }
    }

    update();
  }

  void loadData(ProfileResponseModel? model) {
     // imageUrl='${UrlContainer.baseUrl}/assets/images/user/profile/${model?.data?.user?.image}';
     firstNameController.text=model?.data?.user?.firstname??'';
     profileRepo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.userNameKey, '${model?.data?.user?.firstname??''} ${model?.data?.user?.lastname??''}');
     lastNameController.text = model?.data?.user?.lastname??'';
     emailController.text = model?.data?.user?.email??'';
     mobileNoController.text = model?.data?.user?.mobile??'';
     addressController.text =model?.data?.user?.address?.address??'';
     stateController.text = model?.data?.user?.address?.state??'';
     zipCodeController.text = model?.data?.user?.address?.zip??'';
     cityController.text = model?.data?.user?.address?.city??'';
     countryController.text = model?.data?.user?.address?.country??'';
     isLoading=false;

     update();
  }
}
