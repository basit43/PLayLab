import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:play_lab/core/utils/my_images.dart';
import 'package:play_lab/view/components/auth_image.dart';
import 'package:play_lab/view/components/buttons/circle_button_with_icon.dart';
import 'package:play_lab/view/components/buttons/rounded_loading_button.dart';
import 'package:play_lab/view/screens/splash/splash_screen.dart';
import '../../../../../core/utils/my_color.dart';
import '../../../../constants/my_strings.dart';
import '../../../../core/route/route.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/utils/url_container.dart';
import '../../../../data/controller/auth/login_controller.dart';
import '../../../../data/repo/auth/login_repo.dart';
import '../../../../data/services/api_service.dart';
import '../../../../shared_preference_class.dart';
import '../../../components/bg_widget/bg_image_widget.dart';
import '../../../components/buttons/rounded_button.dart';
import '../../../components/custom_text_form_field.dart';
import '../../bottom_nav_pages/home/home_screen.dart';
import '.././../../../core/utils/dimensions.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool b = false;
  final formKey = GlobalKey<FormState>();

// TODO SELECTED COUNTRY
  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: MyColor.transparentColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: MyColor.colorBlack,
        systemNavigationBarIconBrightness: Brightness.light));

    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LoginRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
    Get.put(LoginController(loginRepo: Get.find()));

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      b = true;
      Get.find<LoginController>().isLoading = false;
      Get.find<LoginController>().remember = false;
    });
  }

  @override
  void dispose() {
    b = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: GetBuilder<LoginController>(
        builder: (auth) => SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              // const MyBgWidget(image: MyImages.onboardingBG,),
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 20, top: 100),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .09,
                        ),
                        const AuthImageWidget(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .06,
                        ),

                        // TODO TEXTFORMFIELD
                        TextFormField(
                          cursorColor: Colors.white,
                          controller: auth.phoneNumberController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                          // onChanged: (value) {
                          //   setState(() {
                          //     auth.phoneNumberController.text = value;
                          //   });
                          // },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[600]!.withOpacity(0.3),
                            hintText: MyStrings.enterPhoneNumberHintText,
                            // Add extra spaces
                            labelText: MyStrings.enterPhoneNumberLabelText,
                            hintStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            labelStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radius * 0.5),
                              borderSide: const BorderSide(
                                  color: Colors.transparent, width: 0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radius * 0.5),
                              borderSide: const BorderSide(
                                  color: Colors.transparent, width: 0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radius * 0.5),
                              borderSide: const BorderSide(
                                  color: MyColor.primaryColor, width: 0.5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radius * 0.5),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 0.5),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radius * 0.5),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 0.5),
                            ),
                            prefixIcon: Container(
                              padding: const EdgeInsets.only(
                                  top: 13.5, left: 10.0, right: 5.0),
                              // Add right padding
                              child: InkWell(
                                onTap: () {
                                  showCountryPicker(
                                    context: context,
                                    countryListTheme:
                                        const CountryListThemeData(
                                      bottomSheetHeight: 500,
                                    ),
                                    onSelect: (value) {
                                      setState(() {
                                        selectedCountry = value;
                                      });
                                    },
                                  );
                                },
                                child: Text(
                                  "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            suffixIcon:
                                auth.phoneNumberController.text.length > 9
                                    ? Container(
                                        height: 30,
                                        width: 30,
                                        margin: const EdgeInsets.all(10.0),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green,
                                        ),
                                        child: const Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      )
                                    : null,
                          ),
                        ),

                        const SizedBox(
                          height: 25.0,
                        ),

                        // InputTextFieldWidget(
                        //   fillColor:Colors.grey[600]!.withOpacity(0.3),
                        //   hintTextColor:Colors.white,
                        //   controller: auth.emailController,
                        //   hintText: MyStrings.enterUserNameOrEmail),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        // InputTextFieldWidget(
                        //     fillColor:Colors.grey[600]!.withOpacity(0.3),hintTextColor:Colors.white,
                        //     isPassword: true,
                        //     controller: auth.passwordController,
                        //     isAddMargin: false,
                        //     hintText: MyStrings.enterYourPassword_),

                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Expanded(
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         children: [
                        //           SizedBox(
                        //             height:23,
                        //             width: 23,
                        //             child: Checkbox(
                        //                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        //                 side: MaterialStateBorderSide.resolveWith((states) => const BorderSide(width: 1.0, color: Colors.white),),
                        //                 activeColor: MyColor.primaryColor,
                        //                 value: auth.remember,
                        //                 onChanged: (value) {
                        //                   auth.changeRememberMe();
                        //                 }),
                        //           ),
                        //           const SizedBox(width: 5),
                        //           Flexible(
                        //             child: Text(
                        //               MyStrings.rememberMe.tr,
                        //               textAlign: TextAlign.start,
                        //               overflow: TextOverflow.ellipsis,
                        //               style: mulishSemiBold.copyWith(
                        //                   color: MyColor.colorWhite,
                        //                   fontSize: Dimensions.fontDefault),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //
                        //     // TODO FORGOT PASSWORD
                        //     Expanded(
                        //       child: GestureDetector(
                        //         onTap: (){
                        //           Get.toNamed(RouteHelper.forgetPasswordScreen);
                        //         },
                        //         child: Text(
                        //           MyStrings.forgetYourPassword.tr,
                        //           textAlign: TextAlign.end,
                        //           overflow: TextOverflow.ellipsis,
                        //           style: mulishSemiBold.copyWith(
                        //               color: MyColor.primaryColor,
                        //               fontSize: Dimensions.fontDefault,decoration: TextDecoration.underline),
                        //         ),
                        //       ),
                        //     )
                        //   ],
                        // ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        auth.isLoading
                            ? const Center(child: RoundedLoadingButton())
                            : RoundedButton(
                                // press: () {
                                //   if (formKey.currentState!.validate()) {
                                //     auth.changeIsLoading();
                                //     // auth.loginUser(auth.emailController.text,
                                //     //     auth.passwordController.text);
                                //
                                //     String phoneNumber = auth.phoneNumberController.text.trim();
                                //
                                //     String formattedPhoneNumber = "+${selectedCountry.phoneCode}$phoneNumber";
                                //
                                //     auth.signInWithPhoneNumber(formattedPhoneNumber, context);
                                //
                                //     // auth.loginUser("917004750012");
                                //     // userLogin("917004750012");
                                //
                                //   }
                                // },
                                press: () {
                                  if (formKey.currentState!.validate()) {
                                    auth.changeIsLoading();
                                    String phoneNumber =
                                        auth.phoneNumberController.text.trim();
                                    // String formattedPhoneNumber = "+${selectedCountry.phoneCode}$phoneNumber";
                                    String formattedPhoneNumber =
                                        "${selectedCountry.phoneCode}$phoneNumber";
                                    userLogin(formattedPhoneNumber);
                                  }
                                },
                                text: MyStrings.sendOtpCode,
                              ),
                        !auth.isAllSocialAuthDisable()
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .02,
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Divider(
                                            color: MyColor.textColor,
                                            thickness: 1.2),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(MyStrings.or.tr),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Expanded(
                                          child: Divider(
                                              color: MyColor.textColor,
                                              thickness: 1.2)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .02,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Platform.isAndroid &&
                                              auth.isSingleSocialAuthEnable(
                                                  isGoogle: true)
                                          ? Expanded(
                                              child: SocialLoginButton(
                                                textColor: Colors.white,
                                                bg: MyColor.gmailColor,
                                                text: MyStrings.google,
                                                press: () {
                                                  auth.signInWithGoogle();
                                                },
                                                imageSize: 30,
                                                fromAsset: true,
                                                isIcon: false,
                                                padding: 0,
                                                circleSize: 30,
                                                imageUrl: MyImages.gmailIcon,
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                      const SizedBox(width: Dimensions.space15),
                                      auth.isSingleSocialAuthEnable(
                                              isGoogle: false)
                                          ? Expanded(
                                              child: SocialLoginButton(
                                                  bg: MyColor.fbColor,
                                                  text: MyStrings.facebook,
                                                  press: () {
                                                    auth.signInWithFacebook();
                                                  },
                                                  imageSize: 30,
                                                  isIcon: false,
                                                  fromAsset: true,
                                                  padding: 0,
                                                  circleSize: 30,
                                                  imageUrl: MyImages.fbIcon))
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .085,
                        ),
                        Center(
                          child: Text(
                            MyStrings.notAccount.tr,
                            style: mulishSemiBold.copyWith(
                                color: MyColor.colorWhite,
                                fontSize: Dimensions.fontLarge),
                          ),
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Get.offAndToNamed(RouteHelper.registrationScreen);
                            },
                            child: Text(
                              MyStrings.signUp.tr,
                              style: mulishBold.copyWith(
                                  fontSize: 18, color: MyColor.primaryColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .06,
                        ),
                        InkWell(
                          splashColor: MyColor.primaryColor,
                          hoverColor: MyColor.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            auth.clearAllSharedData();
                            Get.toNamed(RouteHelper.homeScreen);
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.transparent,
                                border: Border.all(
                                    color: MyColor.textFieldColor, width: 2),
                              ),
                              child: Text(
                                MyStrings.asAGuest.tr,
                                style: mulishSemiBold.copyWith(
                                    color: MyColor.colorWhite),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  userLogin(String phoneNumber) async {
    print("Asim $phoneNumber");

    try {
      final response = await http.post(
          Uri.parse('${UrlContainer.baseUrl}${UrlContainer.otpSendEndPoint}'),
          body: {
            "number": phoneNumber,
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print("Data $data");
        print("Message Sent Successfully.");
        // Check if the 'otp' field exists in the response data
        if (data.containsKey('data') && data['data'].containsKey('otp')) {
          int otp = data['data']['otp'];
          print("OTP is ${otp.toString()}");

          // Ensure that shared preferences is properly initialized
          if (MySharedPrefClass.preferences != null) {
            MySharedPrefClass.preferences!.setBool("loggedIn", true);
            MySharedPrefClass.preferences!.setInt("otp", otp);
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                phoneNumber: phoneNumber,
                otp: otp,
              ),
            ),
          );
        }

        Fluttertoast.showToast(
            msg: "Message Sent Successfully.",
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 18);
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "User with this number is already exist",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 18);
      } else {
        print("Failed");
        Fluttertoast.showToast(
            msg: response.statusCode.toString(),
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 18);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SplashScreen()));
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SplashScreen()));
    }
  }
}
