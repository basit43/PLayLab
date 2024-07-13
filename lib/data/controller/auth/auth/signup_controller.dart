import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:play_lab/constants/my_strings.dart';
import 'package:play_lab/view/components/show_custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../../../../constants/constant_helper.dart';
import '../../../../core/helper/shared_pref_helper.dart';
import '../../../../core/route/route.dart';
import '../../../model/auth/registration_response_model.dart';
import '../../../model/auth/sign_up_model/sign_up_model.dart';
import '../../../model/general_setting/general_settings_response_model.dart';
import '../../../model/global/response_model/response_model.dart';
import '../../../repo/auth/signup_repo.dart';

class SignUpController extends GetxController {
  SignupRepo signupRepo;
  SharedPreferences sharedPreferences;

  SignUpController({required this.signupRepo, required this.sharedPreferences});

  bool isLoading = false;
  bool agreeTC = false;

  GeneralSettingsResponseModel generalSettingsResponseModel =
      GeneralSettingsResponseModel();

  bool checkPasswordStrength = false;
  bool needAgree = true;

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode countryNameFocusNode = FocusNode();
  final FocusNode mobileFocusNode = FocusNode();
  final FocusNode userNameFocusNode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController  = TextEditingController();
  // final TextEditingController cPasswordController = TextEditingController();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  String? email;
  // String? password;
  // String? confirmPassword;
  String? countryName;
  String? countryCode;
  String? mobileCode;
  String? userName;
  String? phoneNo;
  // String? firstName;
  //String? lastName;

  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  signUpUser() async {
    isLoading = true;
    update();
    if (!checkAndAddError()) {
      isLoading = false;
      update();
      return;
    }
    if (errors.isNotEmpty) {
      isLoading = false;
      update();
      return;
    }
    //stdout.writeln('print me');
    SignUpModel model = getUserData();

    final responseModel = await signupRepo.registerUser(model);
    if (responseModel.status == 'success') {
      await checkAndGotoNextStep(responseModel);
    } else {
      CustomSnackbar.showCustomSnackbar(
          errorList: [responseModel.message?.error ?? ''],
          msg: [],
          isError: true);
    }
    isLoading = false;
    update();
  }

  bool checkAndAddError() {
    bool isValid = true;

    if (userNameController.text.isEmpty) {
      isValid = false;
      addError(error: MyStrings.kUserNameNullError);
    }
    if (mobileController.text.isEmpty) {
      isValid = false;
      addError(error: MyStrings.kPhoneNumberNullError);
    }
    if (emailController.text.isEmpty) {
      isValid = false;
      addError(error: MyStrings.kEmailNullError);
    }

    // if (passwordController.text.isEmpty) {
    //   isValid = false;
    //   addError(error: MyStrings.kInvalidPassError);
    // }
    //   if (isValidPassword(passwordController.text.toString())) {
    //     removeError(error: MyStrings.kInvalidPassError);
    //   }
    // if (!(cPasswordController.text.toString() ==
    //     passwordController.text.toString())) {
    //   isValid = false;
    //   addError(error: MyStrings.kMatchPassError);
    // }
    else {
      removeError(error: MyStrings.kMatchPassError);
    }

    return isValid;
  }

  final List<String?> errors = [];

  setCountryNameAndCode(String cName, String countryCode, String mobileCode) {
    countryName = cName;
    this.countryCode = countryCode;
    this.mobileCode = mobileCode;
    update();
  }

  void addError({String? error}) {
    if (!errors.contains(error)) {
      errors.add(error);
      update();
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      errors.remove(error);
      update();
    }
  }

  bool isValidPassword(String value) {
    if (value.isEmpty) {
      return false;
    } else {
      if (checkPasswordStrength) {
        if (!regex.hasMatch(value)) {
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }
    }
  }

  updateAgreeTC() {
    agreeTC = !agreeTC;
    update();
  }

  SignUpModel getUserData() {
    SignUpModel model = SignUpModel(
      mobile: mobileController.text.toString(),
      email: emailController.text.toString(),
      agree: agreeTC ? true : false,
      username: userNameController.text.toString(),
      // password: passwordController.text.toString(),
      country: countryName.toString(),
      mobileCode: mobileCode != null ? mobileCode!.replaceAll("[+]", "") : "",
      countryCode: countryCode ??
          '', /* mobile_code: mobileCode != null ? mobileCode!.replaceAll("[+]", "") : "", mobileCode: '', confirmPassword: '', countryCode: '')*/
    );

    return model;
  }

  Future<void> checkAndGotoNextStep(
      RegistrationResponseModel responseModel) async {
    bool needEmailVerification =
        responseModel.data?.user?.ev == '1' ? false : true;
    bool needSmsVerification =
        responseModel.data?.user?.sv == '1' ? false : true;

    await sharedPreferences.setString(SharedPreferenceHelper.accessTokenKey,
        responseModel.data?.accessToken ?? '');
    await sharedPreferences.setString(SharedPreferenceHelper.accessTokenType,
        responseModel.data?.tokenType ?? '');
    await sharedPreferences.setString(SharedPreferenceHelper.userEmailKey,
        responseModel.data?.user?.email ?? '');
    await sharedPreferences.setString(SharedPreferenceHelper.phoneNumberKey,
        responseModel.data?.user?.mobile ?? '');
    await sharedPreferences.setString(SharedPreferenceHelper.userNameKey,
        responseModel.data?.user?.username ?? '');

    await signupRepo.sendUserToken();
    bool isProfileCompleteEnable = true;

    if (needSmsVerification == false && needEmailVerification == false) {
      Get.offAndToNamed(RouteHelper.loginScreen);
    } else if (needSmsVerification == true && needEmailVerification == true) {
      Get.offAndToNamed(RouteHelper.emailVerificationScreen,
          arguments: [true, isProfileCompleteEnable]);
    } else if (needSmsVerification) {
      Get.offAndToNamed(RouteHelper.smsVerificationScreen,
          arguments: isProfileCompleteEnable);
    } else if (needEmailVerification) {
      Get.offAndToNamed(RouteHelper.emailVerificationScreen,
          arguments: [false, isProfileCompleteEnable]);
    }
  }

  void closeAllController() {
    isLoading = false;
    errors.clear();
    emailController.text = '';
    // passwordController.text='';
    // cPasswordController.text='';
    fNameController.text = '';
    lNameController.text = '';
    mobileController.text = '';
    countryController.text = '';
    userNameController.text = '';
  }

  clearAllData() {
    closeAllController();
  }

  bool isEmailLoginLoading = false;
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      String accessToken = googleAuth.accessToken ?? '';

      if (accessToken.isEmpty) {
        await GoogleSignIn().signOut();
        CustomSnackbar.showCustomSnackbar(
            errorList: [MyStrings.noAccessTokenFound], msg: [], isError: true);
      } else {
        isEmailLoginLoading = true;
        update();

        String email = googleUser.email;
        String name = googleUser.displayName ?? '';
        String id = googleUser.id;

        await GoogleSignIn().signOut();
        await sendSocialLoginRequest(true, accessToken, email, name, id);

        isEmailLoginLoading = false;
        update();
      }
    }
  }

  bool facebookLoginLoading = false;
  Future<void> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();

        String name = userData['name'];
        String email = userData['email'];
        String uid = userData['id'];
        String token = loginResult.accessToken?.tokenString ?? '';

        await sendSocialLoginRequest(false, token, email, name, uid);
      }
    } catch (e) {
      PrintHelper.printHelper(e.toString());
    }
  }

  Future<void> sendSocialLoginRequest(bool isGmail, String accessToken,
      String email, String name, String id) async {
    ResponseModel responseModel =
        await signupRepo.socialLogin(isGmail, accessToken, email, name, id);
    if (responseModel.statusCode == 200) {
      RegistrationResponseModel loginModel = RegistrationResponseModel.fromJson(
          jsonDecode(responseModel.responseJson));
      if (loginModel.status == 'error') {
        return;
      } else {
        checkAndGotoNextStep(loginModel);
      }
    }
  }
}
