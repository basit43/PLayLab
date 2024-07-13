import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:play_lab/constants/constant_helper.dart';
import 'package:play_lab/constants/my_strings.dart';
import 'package:play_lab/data/model/auth/login_response_model.dart';
import 'package:play_lab/data/model/global/response_model/response_model.dart';
import 'package:play_lab/view/components/show_custom_snackbar.dart';

import '../../../core/helper/shared_pref_helper.dart';
import '../../../core/route/route.dart';
import '../../../core/utils/url_container.dart';
import '../../../view/screens/auth/login/otp_screen.dart';
import '../../repo/auth/login_repo.dart';

class LoginController extends GetxController {
  LoginRepo loginRepo;

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  List<String> errors = [];
  String? email;
  String? password;
  bool isLoading = false;
  bool remember = false;

  LoginController({required this.loginRepo});

  void forgetPassword() {
    Get.toNamed(RouteHelper.forgetPasswordScreen);
  }

  void checkAndGotoNextStep(LoginResponseModel responseModel) async {
    isLoading = true;
    update();

    // bool needEmailVerification = responseModel.data?.user?.ev.toString() == "0"?true: false;
    bool needSmsVerification =
        responseModel.data?.user?.sv.toString() == '0' ? true : false;
    String expDate = responseModel.data?.user?.exp ?? '';

    loginRepo.apiClient.storeExpiredDate(expDate);

    await loginRepo.apiClient.sharedPreferences
        .setBool(SharedPreferenceHelper.rememberMeKey, remember ? true : false);
    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.accessTokenKey,
        responseModel.data?.accessToken ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.accessTokenType,
        responseModel.data?.tokenType ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.userEmailKey,
        responseModel.data?.user?.email ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.phoneNumberKey,
        responseModel.data?.user?.mobile ?? '');
    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.userNameKey,
        responseModel.data?.user?.username ?? '');

    await loginRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.userNameKey,
        '${responseModel.data?.user?.firstname ?? ''} ${responseModel.data?.user?.lastname ?? ''}');

    await loginRepo.sendUserToken();

    bool isProfileCompleteEnable =
        responseModel.data?.user?.regStep == '0' ? true : false;

    if (needSmsVerification == false) {
      if (isProfileCompleteEnable) {
        Get.offAndToNamed(RouteHelper.profileComplete);
      } else {
        Get.offAndToNamed(RouteHelper.homeScreen);
      }
    } else if (needSmsVerification == true) {
      Get.offAndToNamed(RouteHelper.emailVerificationScreen,
          arguments: [true, isProfileCompleteEnable]);
    } else if (needSmsVerification) {
      Get.offAndToNamed(RouteHelper.smsVerificationScreen,
          arguments: isProfileCompleteEnable);
    }
    // else if(needEmailVerification){
    //   Get.offAndToNamed(RouteHelper.emailVerificationScreen,arguments: [false,isProfileCompleteEnable]);
    // }

    changeIsLoading();

    if (remember) {
      changeRememberMe();
    }
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

  String _verificationid = "";
  int? _resendtoken;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // TODO SIGN IN WITH PHONE NUMBER
  Future<void> signInWithPhoneNumber(String? phoneNumber, context) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
          // Handle other verification failures here
          // Set isRegistering to false to stop the circular progress indicator
          // isRegistering = false;
          Fluttertoast.showToast(msg: "Failed to verify phone number");
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationid = verificationId;
          _resendtoken = resendToken;
          if (kDebugMode) {
            print("Code Sent: $verificationId");
          }

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => OtpScreen(verificationId: verificationId, phoneNumber: phoneNumber,),
          //   ),
          // );
        },
        timeout: const Duration(seconds: 25),
        forceResendingToken: _resendtoken,
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = _verificationid;
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      // Handle other exceptions here
      // Set isRegistering to false to stop the circular progress indicator
      // isRegistering = false;
      Fluttertoast.showToast(msg: "Failed to initiate phone verification");
    }
  }

  // TODO LOGIN WITH FACEBOOK
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
      } else {}
    } catch (e) {
      PrintHelper.printHelper(e.toString());
    }

    // Create a credential from the access token
  }

  // TODO SOCIAL LOGIN REQUEST
  Future<void> sendSocialLoginRequest(bool isGmail, String accessToken,
      String email, String name, String id) async {
    ResponseModel responseModel =
        await loginRepo.socialLogin(isGmail, accessToken, email, name, id);
    if (responseModel.statusCode == 200) {
      LoginResponseModel loginModel =
          LoginResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (loginModel.status == 'error') {
        CustomSnackbar.showCustomSnackbar(errorList: [
          loginModel.message?.error?.toString() ??
              'user login failed , pls try again'
        ], msg: [], isError: true);
        changeIsLoading();
        return;
      } else {
        checkAndGotoNextStep(loginModel);
      }
    }
  }

  // TODO LOGIN USER
  loginUser(String phoneNumber) async {
    print("PhoneNumber $phoneNumber");

    ResponseModel? model = await loginRepo.loginUser(phoneNumber);

    if (model!.statusCode == 200) {
      LoginResponseModel loginModel =
          LoginResponseModel.fromJson(jsonDecode(model.responseJson));
      if (loginModel.status == 'error') {
        CustomSnackbar.showCustomSnackbar(errorList: [
          loginModel.message?.error?.toString() ??
              'user login failed , pls try again'
        ], msg: [], isError: true);
        changeIsLoading();
        return;
      } else {
        checkAndGotoNextStep(loginModel);
      }
    } else {
      CustomSnackbar.showCustomSnackbar(
          errorList: [model.message], msg: [], isError: false);
      changeIsLoading();
    }
  }

  void changeIsLoading() {
    isLoading = !isLoading;
    update();
  }

  changeRememberMe() {
    remember = !remember;
    update();
  }

  rememberMe() async {
    await loginRepo.apiClient.sharedPreferences
        .setBool(SharedPreferenceHelper.rememberMeKey, true);
  }

  void clearAllSharedData() {
    loginRepo.apiClient.sharedPreferences
        .setBool(SharedPreferenceHelper.rememberMeKey, false);
    loginRepo.apiClient.sharedPreferences
        .setString(SharedPreferenceHelper.accessTokenKey, '');
    return;
  }

  bool isAllSocialAuthDisable() {
    bool isFbAuthEnable = loginRepo.apiClient.isFacebookAuthEnable();
    bool isGmailAuthEnable = loginRepo.apiClient.isGmailAuthEnable();

    if (!isFbAuthEnable && !isGmailAuthEnable) {
      return true;
    } else {
      return false;
    }
  }

  bool isSingleSocialAuthEnable({bool isGoogle = false}) {
    bool isEnable = isGoogle
        ? loginRepo.apiClient.isGmailAuthEnable()
        : loginRepo.apiClient.isFacebookAuthEnable();
    return isEnable;
  }
}
