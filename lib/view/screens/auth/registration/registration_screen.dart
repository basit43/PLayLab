import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_lab/view/components/buttons/rounded_loading_button.dart';

import '../../../../constants/my_strings.dart';
import '../../../../core/route/route.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_images.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/utils/util.dart';
import '../../../../data/controller/auth/auth/signup_controller.dart';
import '../../../../data/repo/auth/general_setting_repo.dart';
import '../../../../data/repo/auth/signup_repo.dart';
import '../../../../data/services/api_service.dart';
import '../../../components/auth_image.dart';
import '../../../components/buttons/circle_button_with_icon.dart';
import '../../../components/custom_back_support_appbar.dart';
import '../../../components/bg_widget/bg_image_widget.dart';
import '../../../components/custom_text_field.dart';
import '../../../components/custom_text_field_for_phone.dart';
import '../../../components/from_errors.dart';
import '../../../components/buttons/rounded_button.dart';
import '../../../components/text_field_container2.dart';



class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  TextEditingController phoneNumberController = TextEditingController();


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

    MyUtil.changeTheme();
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(GeneralSettingRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
    Get.put(SignupRepo(apiClient: Get.find()));
    Get.put(SignUpController(signupRepo: Get.find(), sharedPreferences: Get.find()));

    super.initState();
  }

  String? selectedValue;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // const MyBgWidget(),
        GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppBar().preferredSize.height),
              child: CustomBackSupportAppBar(
                  title: MyStrings.signUp,
                  press: () {
                    Get.find<SignUpController>().clearAllData();
                    Get.offAndToNamed(RouteHelper.loginScreen);
                  }),
            ),
            body: GetBuilder<SignUpController>(
              builder: (controller) => SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height*.02,
                        ),
                        const AuthImageWidget(),
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height*.05,
                        // ),
                        //
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Platform.isAndroid?Expanded(
                        //       child: SocialLoginButton(
                        //         bg: MyColor.gmailColor,
                        //         text:MyStrings.google,
                        //         press: (){
                        //           controller.signInWithGoogle();
                        //         },imageSize: 30,fromAsset:true,isIcon:false,padding: 0,circleSize: 30,imageUrl: MyImages.gmailIcon,),
                        //     ):const SizedBox.shrink(),
                        //     const SizedBox(width: Dimensions.space15),
                        //     /*CircleButtonWithIcon(press: (){
                        //        auth.signInWithApple();
                        //      },imageSize: 30,fromAsset:true,isIcon:false,padding: 0,circleSize: 30,imageUrl: MyImages.appleIcon,),
                        //      const SizedBox(width: Dimensions.space15),*/
                        //     Expanded(child:  SocialLoginButton(
                        //         bg: MyColor.fbColor,
                        //         text:MyStrings.facebook,
                        //         press: (){
                        //           controller.signInWithFacebook();
                        //         },imageSize: 30,isIcon:false,fromAsset:true,padding: 0,circleSize: 30,imageUrl: MyImages.fbIcon)),
                        //   ],
                        // ),
                        //
                        //
                        // SizedBox(height: MediaQuery.of(context).size.height*.02,),
                        // Row(
                        //   children: [
                        //     const Expanded(child: Divider(color: MyColor.textColor,thickness: 1.2),),
                        //     const SizedBox(width: 10,),
                        //     Text(MyStrings.or.tr),
                        //     const SizedBox(width: 10,),
                        //     const Expanded(child: Divider(color: MyColor.textColor,thickness: 1.2)),
                        //   ],
                        // ),
                        //
                        //
                        SizedBox(height: MediaQuery.of(context).size.height*.08,),
                        CustomTextField(
                          fillColor: MyColor.textFiledFillColor,
                          controller: controller.userNameController,
                          focusNode: controller.userNameFocusNode,
                          inputType: TextInputType.text,
                          nextFocus: controller.emailFocusNode,
                          hintText: MyStrings.userName,
                          maxLines: 1,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              controller.removeError(error: MyStrings.kUserNameNullError);
                            } else {
                              controller.addError(error: MyStrings.kUserNameNullError);
                            }
                            if (value.toString().length < 6) {
                              controller.addError(error: MyStrings.kShortUserNameError);
                            } else {
                              controller.removeError(error: MyStrings.kShortUserNameError);
                            }

                            return;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          fillColor: MyColor.textFiledFillColor,
                          controller: controller.emailController,
                          focusNode: controller.emailFocusNode,
                          hintText: MyStrings.email,
                          inputType: TextInputType.emailAddress,
                          inputAction: TextInputAction.next,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              controller.removeError(error: MyStrings.kEmailNullError);
                            } else {
                              controller.addError(error: MyStrings.kEmailNullError);
                            }
                            if (MyStrings.emailValidatorRegExp.hasMatch(value)) {
                              controller.removeError(error: MyStrings.kInvalidEmailError);
                            } else {
                              controller.addError(error: MyStrings.kInvalidEmailError);
                            }
                              return;
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldContainer2(
                          fillColor: MyColor.textFiledFillColor,
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              countryListTheme: CountryListThemeData(
                                inputDecoration: InputDecoration(
                                  labelText: MyStrings.search.tr,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                                  disabledBorder:   OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(width: 1,color:MyColor.gbr),
                                  ),
                                  focusedBorder:  const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                    borderSide:  BorderSide(width: 1,color:MyColor.primaryColor),
                                  ),
                                  enabledBorder:  OutlineInputBorder(
                                    borderRadius:  const BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(width: 1,color:MyColor.gbr),
                                  ),
                                  errorBorder:  const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(width: 1,color: Colors.red)
                                  ),
                                  focusedErrorBorder:  const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                      borderSide:  BorderSide(width: 1,color: Colors.red)
                                  ),
                                  isDense: true,
                                  hintText: MyStrings.search.tr,
                                  hintStyle: mulishSemiBold.copyWith(color: MyColor.textColor),
                                  labelStyle: mulishSemiBold.copyWith(color: MyColor.textColor),
                                  fillColor: MyColor.transparentColor,
                                  filled: true,)),
                              showPhoneCode: true,
                              onSelect: (Country country) {
                                controller.countryController.text = country.name;
                                controller.setCountryNameAndCode(country.name, country.countryCode, country.phoneCode);
                              },
                            );
                          },
                          child: CustomTextField(
                            inputType: TextInputType.phone,
                            isEnabled: false,
                            fillColor: MyColor.textFiledFillColor,
                            isShowSuffixIcon: true,
                            isCountryPicker: true,
                            isIcon: true,
                            controller: controller.countryController,
                            hintText: MyStrings.pickACountry,
                            onChanged: (value) {
                              return;
                            },
                          ),
                        ),
                        const SizedBox(height: 10,),


                        // TODO TEXTFORMFIELD
                        // Padding(
                        //   padding:
                        //   const EdgeInsets.symmetric(horizontal: 1.0),
                        //   child: TextFormField(
                        //     cursorColor: Colors.white,
                        //     controller: phoneNumberController,
                        //     keyboardType: TextInputType.number,
                        //     style: const TextStyle(
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.w400,
                        //     ),
                        //     onChanged: (value) {
                        //       setState(() {
                        //         phoneNumberController.text = value;
                        //       });
                        //     },
                        //     decoration: InputDecoration(
                        //       filled: true,
                        //       fillColor: Colors.grey[600]!.withOpacity(0.3),
                        //       hintText: MyStrings.enterPhoneNumberHintText,
                        //       // Add extra spaces
                        //       labelText: MyStrings.enterPhoneNumberLabelText,
                        //       hintStyle: const TextStyle(
                        //         color: Colors.white,
                        //       ),
                        //       labelStyle: const TextStyle(
                        //         color: Colors.white,
                        //       ),
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
                        //         borderSide:const BorderSide(
                        //             color: Colors.transparent, width: 0
                        //         ),
                        //       ),
                        //       enabledBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
                        //         borderSide: const BorderSide(color: Colors.transparent, width: 0),
                        //       ),
                        //       focusedBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
                        //         borderSide:const BorderSide(color: MyColor.primaryColor, width: 0.5),
                        //       ),
                        //       errorBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
                        //         borderSide: const BorderSide(color: Colors.red, width: 0.5),
                        //       ),
                        //       focusedErrorBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
                        //         borderSide: const BorderSide(color: Colors.red, width: 0.5),
                        //       ),
                        //       prefixIcon: Container(
                        //         padding: const EdgeInsets.only(
                        //             top: 13.5, left: 10.0, right: 5.0),
                        //         // Add right padding
                        //         child: InkWell(
                        //           onTap: () {
                        //             showCountryPicker(
                        //               context: context,
                        //               countryListTheme:
                        //               const CountryListThemeData(
                        //                 bottomSheetHeight: 500,
                        //               ),
                        //               onSelect: (value) {
                        //                 setState(() {
                        //                   selectedCountry = value;
                        //                 });
                        //               },
                        //             );
                        //           },
                        //           child: Text(
                        //             "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                        //             style: const TextStyle(
                        //               fontSize: 16,
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       suffixIcon:
                        //       phoneNumberController.text.length > 9
                        //           ? Container(
                        //         height: 30,
                        //         width: 30,
                        //         margin:
                        //         const EdgeInsets.all(10.0),
                        //         decoration: const BoxDecoration(
                        //           shape: BoxShape.circle,
                        //           color: Colors.green,
                        //         ),
                        //         child: const Icon(
                        //           Icons.done,
                        //           color: Colors.white,
                        //           size: 20,
                        //         ),
                        //       )
                        //           : null,
                        //     ),
                        //   ),
                        // ),


                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            TextFieldContainer2(
                                fillColor: MyColor.textFiledFillColor,
                                isShowSuffixView: true,
                                prefixWidgetValue:'+${controller.mobileCode ?? ' '}',
                                child: CustomTextFieldForPhone(
                                  controller: controller.mobileController,
                                  focusNode: controller.mobileFocusNode,
                                  inputType: TextInputType.phone,
                                  fillColor: MyColor.textFiledFillColor,
                                  hintText: MyStrings.phoneNumber,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      controller.removeError(error: MyStrings.kPhoneNumberNullError);
                                    } else if (value.isEmpty) {
                                      controller.addError(error: MyStrings.kPhoneNumberNullError);
                                    }
                                    return;
                                  },
                                ),
                                onTap: () {}),
                          ],
                        ),



                        // TODO CONDITION BASED PHONE NUMBER TEXTFORMFIELD APPEAR
                        // controller.countryName == null
                        //     ? const SizedBox()
                        //     : Column(
                        //         children: [
                        //           const SizedBox(
                        //             height: 10,
                        //           ),
                        //           TextFieldContainer2(
                        //               fillColor: MyColor.textFiledFillColor,
                        //               isShowSuffixView: true,
                        //               prefixWidgetValue:'+${controller.mobileCode ?? ' '}',
                        //               child: CustomTextFieldForPhone(
                        //                 controller: controller.mobileController,
                        //                 focusNode: controller.mobileFocusNode,
                        //                 inputType: TextInputType.phone,
                        //                 fillColor: MyColor.textFiledFillColor,
                        //                 hintText: MyStrings.phoneNumber,
                        //                 onChanged: (value) {
                        //                   if (value.isNotEmpty) {
                        //                     controller.removeError(error: MyStrings.kPhoneNumberNullError);
                        //                   } else if (value.isEmpty) {
                        //                     controller.addError(error: MyStrings.kPhoneNumberNullError);
                        //                   }
                        //                   return;
                        //                 },
                        //               ),
                        //               onTap: () {}),
                        //         ],
                        //       ),


                        const SizedBox(
                          height: 10,
                        ),

                        // TODO PASSWORD AND CONFIRM PASSWORD TEXT FORM FIELDS
                        // CustomTextField(
                        //     controller: controller.passwordController,
                        //     focusNode: controller.passwordFocusNode,
                        //     nextFocus: controller.confirmPasswordFocusNode,
                        //     hintText: MyStrings.password,
                        //     isShowSuffixIcon: true,
                        //     isPassword: true,
                        //     fillColor: MyColor.textFiledFillColor,
                        //     inputType: TextInputType.text,
                        //     onChanged: (value) {
                        //       if (value.isNotEmpty) {
                        //         controller.removeError(error: MyStrings.kPassNullError);
                        //       } else {
                        //         controller.addError(error: MyStrings.kPassNullError);
                        //       }
                        //       if (controller.isValidPassword(controller.passwordController.text.toString())) {
                        //         controller.removeError(error: MyStrings.kInvalidPassError);
                        //       } else {
                        //         controller.addError(error: MyStrings.kInvalidPassError);
                        //       }
                        //       return;
                        //     }),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // CustomTextField(
                        //     fillColor: MyColor.textFiledFillColor,
                        //     controller: controller.cPasswordController,
                        //     focusNode: controller.confirmPasswordFocusNode,
                        //     inputAction: TextInputAction.done,
                        //     isPassword: true,
                        //     hintText: MyStrings.confirmPassword,
                        //     isShowSuffixIcon: true,
                        //     onChanged: (value) {
                        //       if (controller.passwordController.text.isEmpty) {
                        //         return;
                        //       } else if (controller.passwordController.text.toString() == value) {
                        //         controller.removeError(error: MyStrings.kMatchPassError);
                        //         return;
                        //       } else {
                        //         controller.addError(error: MyStrings.kMatchPassError);
                        //         return;
                        //       }
                        //     }),



                        const SizedBox(
                          height: 10,
                        ),
                        controller.needAgree
                            ? Row(
                                children: [
                                  SizedBox(
                                    child: Checkbox(
                                        side: MaterialStateBorderSide.resolveWith(
                                            (states) => const BorderSide(
                                        width: 2, color: Colors.white)),
                                        activeColor: MyColor.primaryColor,
                                        value: controller.agreeTC,
                                        onChanged: (value) {
                                          controller.updateAgreeTC();
                                        }),
                                  ),
                                  Flexible(
                                      child: Text.rich(TextSpan(
                                          text: '${MyStrings.iAgreeWith.tr} ',
                                          style: mulishRegular,
                                          children: [
                                        TextSpan(
                                            text: MyStrings.policies.tr,
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Get.toNamed(RouteHelper.privacyScreen);
                                              },
                                            style: mulishBold.copyWith(
                                                color: Colors.red,
                                                decoration: TextDecoration.underline)),
                                      ])))
                                ],
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(
                          height: 10,
                        ),
                        FormError(errors: controller.errors),
                        const SizedBox(
                          height: 20,
                        ),
                        controller.isLoading
                            ? const RoundedLoadingButton()
                            : RoundedButton(
                                text: MyStrings.submit,
                                press: () {
                                  controller.signUpUser();
                                },
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
