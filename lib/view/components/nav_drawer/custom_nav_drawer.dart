import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:play_lab/view/components/auth_image.dart';
import 'package:play_lab/view/components/buttons/rounded_button.dart';
import 'package:play_lab/view/components/delete_account_dialog/delete_account_dialog.dart';
import 'package:play_lab/view/components/show_custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/my_strings.dart';
import '../../../core/helper/shared_pref_helper.dart';
import '../../../core/route/route.dart';
import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/my_images.dart';
import '../../../core/utils/styles.dart';
import '../../../core/utils/url_container.dart';
import '../../../data/controller/nav_controller/nav_drawer_controller.dart';
import '../../../data/enum/navigation_item.dart';
import '../../../data/model/auth/login_response_model.dart';
import '../../../data/repo/auth/login_repo.dart';
import '../../../data/services/api_service.dart';
import '../../../shared_preference_class.dart';
import '../language/language_dialog.dart';

class NavigationDrawerWidget extends StatefulWidget {
  static const padding = EdgeInsets.symmetric(horizontal: 20);
  static NavigationItem navigationItem = NavigationItem.profileSetting;

  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {


  LoginResponseModel? loginResponseModel;

  String? name, email;

  @override
  void initState() {
    Get.put(LoginRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
    Get.put(NavDrawerController(sharedPreferences: Get.find()));
    loginResponseModel = LoginResponseModel();
    name = MySharedPrefClass.preferences!.getString("name");
    email = MySharedPrefClass.preferences!.getString("email");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // String? email = (Get.find<LoginRepo>().sharedPreferences.getString(SharedPreferenceHelper.userEmailKey) ?? '');
    // String? name = Get.find<LoginRepo>().sharedPreferences.getString(SharedPreferenceHelper.userNameKey) ?? '';
    double space = 3;

    return Drawer(
      child: Container(
        color: MyColor.secondaryColor,
        child: ListView(
          children: <Widget>[
            buildHeader(
              context,
              urlImage: MyImages.profile,
              name: name ?? "Name",
              email: email ?? "Email"
            ),
            Container(
              padding: NavigationDrawerWidget.padding,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  buildMenuItem(
                    context,
                    item: NavigationItem.payment,
                    text:MyStrings.wishList,
                    index: 9,
                    icon: Icons.favorite_outline,
                  ),
                  SizedBox(height: space),
                  buildMenuItem(
                    context,
                    index: 1,
                    item: NavigationItem.profileSetting,
                    text:MyStrings.profileSetting,
                    icon: Icons.settings,
                  ),
                  SizedBox(height: space),
                  buildMenuItem(
                    context,
                    item: NavigationItem.products,
                    text:MyStrings.products,
                    index: 2,
                    icon: Icons.key_outlined,
                  ),
                  SizedBox(height: space),
                  buildMenuItem(
                    context,
                    item: NavigationItem.subscribe,
                    text:MyStrings.subscribe,
                    index: 4,
                    icon: Icons.subscriptions_outlined,
                  ),
                  SizedBox(height: space),
                  buildMenuItem(
                    context,
                    item: NavigationItem.history,
                    text:MyStrings.history,
                    index: 5,
                    icon: Icons.history,
                  ),
                  SizedBox(height: space),
                  buildMenuItem(
                    context,
                    item: NavigationItem.payment,
                    text:MyStrings.payment,
                    index: 6,
                    icon: Icons.payment,
                  ),
                  SizedBox(height: space),
                  /*buildMenuItem(
                    context,
                    item: NavigationItem.language,
                    text:MyStrings.language,
                    index: 10,
                    icon: Icons.language,
                  ),*/
                  SizedBox(height: space),
                  buildMenuItem(
                    context,
                    item: NavigationItem.about,
                    text:MyStrings.policies,
                    index: 7,
                    icon: Icons.roundabout_left,
                  ),
                  SizedBox(height: space),
                  buildMenuItem(
                    context,
                    item: NavigationItem.logout,
                    text:MyStrings.logout,
                    index: 8,
                    icon: Icons.logout,
                  ),
                  buildMenuItem(
                    context,
                    item: NavigationItem.delete,
                    text:MyStrings.delete,
                    index: 12,
                    icon: Icons.delete_outline,
                  ),
                ],
              ),
            ),
          ],
        )
        //     :
        // ListView(
        //   children: <Widget>[
        //     buildHeader(
        //         context,
        //         urlImage: MyImages.profile,
        //         name: name,
        //         email: email,
        //         isGuest: true
        //     ),
        //     Container(
        //       padding: NavigationDrawerWidget.padding,
        //       height: MediaQuery.of(context).size.height,
        //       color: Colors.transparent,
        //       child: Column(
        //         children: [
        //           const SizedBox(height: 200,),
        //           Center(child: Text(MyStrings.notLogIn.tr,style: mulishSemiBold.copyWith(fontSize:Dimensions.fontLarge,color: Colors.white),)),
        //           const SizedBox(height: 30,),
        //           RoundedButton(text: MyStrings.login, press: (){
        //             Get.offAndToNamed(RouteHelper.loginScreen);
        //
        //             // userLogin('917004750012');
        //
        //           })
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );

    // return GetBuilder<NavDrawerController>(
    //     builder: (controller) => Drawer(
    //           child: Container(
    //             color: MyColor.secondaryColor,
    //             child: isAuthorized()?ListView(
    //               children: <Widget>[
    //                 buildHeader(
    //                   context,
    //                   urlImage: MyImages.profile,
    //                   name: name,
    //                   email: email,
    //                 ),
    //                 Container(
    //                   padding: NavigationDrawerWidget.padding,
    //                   child: Column(
    //                     children: [
    //                       const SizedBox(height: 24),
    //                       buildMenuItem(
    //                         context,
    //                         item: NavigationItem.payment,
    //                         text:MyStrings.wishList,
    //                         index: 9,
    //                         icon: Icons.favorite_outline,
    //                       ),
    //                       SizedBox(height: space),
    //                       buildMenuItem(
    //                         context,
    //                         index: 1,
    //                         item: NavigationItem.profileSetting,
    //                         text:MyStrings.profileSetting,
    //                         icon: Icons.settings,
    //                       ),
    //                       SizedBox(height: space),
    //                       buildMenuItem(
    //                         context,
    //                         item: NavigationItem.changePassword,
    //                         text:MyStrings.changePassword,
    //                         index: 2,
    //                         icon: Icons.key_outlined,
    //                       ),
    //                       SizedBox(height: space),
    //                       buildMenuItem(
    //                         context,
    //                         item: NavigationItem.subscribe,
    //                         text:MyStrings.subscribe,
    //                         index: 4,
    //                         icon: Icons.subscriptions_outlined,
    //                       ),
    //                       SizedBox(height: space),
    //                       buildMenuItem(
    //                         context,
    //                         item: NavigationItem.history,
    //                         text:MyStrings.history,
    //                         index: 5,
    //                         icon: Icons.history,
    //                       ),
    //                       SizedBox(height: space),
    //                       buildMenuItem(
    //                         context,
    //                         item: NavigationItem.payment,
    //                         text:MyStrings.payment,
    //                         index: 6,
    //                         icon: Icons.payment,
    //                       ),
    //                       SizedBox(height: space),
    //                       buildMenuItem(
    //                         context,
    //                         item: NavigationItem.language,
    //                         text:MyStrings.language,
    //                         index: 10,
    //                         icon: Icons.language,
    //                       ),
    //                       SizedBox(height: space),
    //                       buildMenuItem(
    //                         context,
    //                         item: NavigationItem.about,
    //                         text:MyStrings.policies,
    //                         index: 7,
    //                         icon: Icons.roundabout_left,
    //                       ),
    //                       SizedBox(height: space),
    //                       buildMenuItem(
    //                         context,
    //                         item: NavigationItem.logout,
    //                         text:MyStrings.logout,
    //                         index: 8,
    //                         icon: Icons.logout,
    //                       ),
    //                       buildMenuItem(
    //                         context,
    //                         item: NavigationItem.delete,
    //                         text:MyStrings.delete,
    //                         index: 12,
    //                         icon: Icons.delete_outline,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             )
    //                 : ListView(
    //               children: <Widget>[
    //                 buildHeader(
    //                   context,
    //                   urlImage: MyImages.profile,
    //                   name: name,
    //                   email: email,
    //                   isGuest: true
    //                 ),
    //                 Container(
    //                   padding: NavigationDrawerWidget.padding,
    //                   height: MediaQuery.of(context).size.height,
    //                   color: Colors.transparent,
    //                   child: Column(
    //                     children: [
    //                      const SizedBox(height: 200,),
    //                      Center(child: Text(MyStrings.notLogIn.tr,style: mulishSemiBold.copyWith(fontSize:Dimensions.fontLarge,color: Colors.white),)),
    //                      const SizedBox(height: 30,),
    //                      RoundedButton(text: MyStrings.login, press: (){
    //                          Get.offAndToNamed(RouteHelper.loginScreen);
    //
    //                        // userLogin('917004750012');
    //
    //                      })
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         )
    // );
  }

  Widget buildMenuItem(
    BuildContext context, {
    required NavigationItem item,
    required String text,
    required IconData icon,
    int notification = 0,
    required int index,
  }) {
    return InkWell(
      hoverColor: MyColor.primaryColor500,
      splashColor: MyColor.primaryColor500,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.transparent,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 15),
          selected: false,
          selectedTileColor: Colors.white,
          leading: Icon(icon, color: MyColor.primaryColor),
          title: Text(
              text.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              )),
          onTap: () => selectItem(index, item),
        ),
      ),
    );
  }



  // userLogin(String phoneNumber) async {
  //   print("Asim $phoneNumber");
  //
  //   // Remove the '+' from the beginning
  //   String phoneNumberWithoutPlus = phoneNumber.substring(0);
  //
  //   // Now you can use phoneNumberWithoutPlus for further processing
  //   print('Phone number without plus: $phoneNumberWithoutPlus');
  //
  //
  //   try {
  //     final response = await http.post(
  //         Uri.parse('https://playnow.easyretailer.online/api/login'),
  //         body: {
  //           "mobile": phoneNumberWithoutPlus,
  //         });
  //
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       print("Data $data");
  //       LoginResponseModel loginModel = LoginResponseModel.fromJson(data);
  //       print("Login Model ${loginModel.data}");
  //       print("Login Successfully");
  //       MySharedPrefClass.preferences!.setBool("loggedIn", true);
  //       // MySharedPrefClass.preferences?.setString("Access_Token", data["token"]);
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  //       Fluttertoast.showToast(
  //           msg: "Login Successfully",
  //           backgroundColor: Colors.green,
  //           textColor: Colors.white,
  //           fontSize: 18);
  //     } else if (response.statusCode == 401) {
  //       Fluttertoast.showToast(
  //           msg: "User with this email is already exist",
  //           backgroundColor: Colors.redAccent,
  //           textColor: Colors.white,
  //           fontSize: 18);
  //     } else {
  //       print("Failed");
  //       Fluttertoast.showToast(
  //           msg: response.statusCode.toString(),
  //           backgroundColor: Colors.redAccent,
  //           textColor: Colors.white,
  //           fontSize: 18);
  //       Navigator.pushReplacement(context,
  //           MaterialPageRoute(builder: (context) => const LoginScreen()));
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     Fluttertoast.showToast(
  //         msg: e.toString(),
  //         backgroundColor: Colors.redAccent,
  //         textColor: Colors.white,
  //         fontSize: 18);
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(builder: (context) => const LoginScreen()));
  //   }
  // }



  void selectItem(int index, NavigationItem item) {
    NavigationDrawerWidget.navigationItem = item;

    if (index == 1) {
      bool isOk = isAuthorized();
      if (isOk) {
        Get.toNamed(RouteHelper.profileScreen);
      } else {
        showErrorSnackbar();
      }
    }
    else if (index == 2) {
      bool isOk = isAuthorized();
      if (isOk) {
        Get.toNamed(RouteHelper.productsScreen);
      } else {
        showErrorSnackbar();
      }
    }
    else if (index == 4) {
      bool isOk = isAuthorized();
      if (isOk) {
        Get.toNamed(RouteHelper.subscribeScreen);
      } else {
        showErrorSnackbar();
      }
    } else if (index == 5) {
      bool isOk = isAuthorized();
      if (isOk) {
        Get.toNamed(RouteHelper.myWatchHistoryScreen);
      } else {
        showErrorSnackbar();
      }
    } else if (index == 6) {
      bool isOk = isAuthorized();
      if (isOk) {
        Get.toNamed(RouteHelper.paymentHistoryScreen);
      } else {
        showErrorSnackbar();
      }
    } else if (index == 7) {
      Get.toNamed(RouteHelper.privacyScreen);
    } else if (index == 8) {
      logOutUser();
    }else if (index == 9) {
      bool isOk = isAuthorized();
      if (isOk) {
        Get.toNamed(RouteHelper.wishListScreen);
      } else {
        showErrorSnackbar();
      }
    }
    else if (index == 10) {
      final apiClient = Get.put(ApiClient(sharedPreferences: Get.find()));
      SharedPreferences pref = apiClient.sharedPreferences;
      String language = pref.getString(SharedPreferenceHelper.langListKey)  ??'';
      String countryCode = pref.getString(SharedPreferenceHelper.countryCode)   ??'US';
      String languageCode = pref.getString(SharedPreferenceHelper.langCode) ??'en';
      Locale local = Locale(languageCode,countryCode);
      showLanguageDialog(language, local, context);
    }

    else if (index == 12) {
      showDeleteDialog(context);
    }
    Scaffold.of(context).closeDrawer();
  }

  void showErrorSnackbar() {
    CustomSnackbar.showCustomSnackbar(errorList: [
      MyStrings.guestUserAlert.tr
    ], msg: [], isError: true);
  }

  bool isAuthorized() {
    String? value = name;
    return value == null ? false : value.isEmpty ? false : true;
  }

  void logOutUser() async {

    MySharedPrefClass.logout(context);
    Navigator.pushReplacementNamed(context, RouteHelper.splashScreen);

    bool status=await Get.find<NavDrawerController>().logout(context);

    if(!status){
      CustomSnackbar.showCustomSnackbar(errorList: [] ,msg: [MyStrings.youHaveLoggedOut.tr], isError: false);
    }

    Get.find<LoginRepo>().sharedPreferences.setString(SharedPreferenceHelper.accessTokenKey,'');
    Get.find<LoginRepo>().sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey,false);
    Get.find<LoginRepo>().sharedPreferences.setString(SharedPreferenceHelper.accessTokenType,'');

  }

  void banUser() async {

    bool status = await Get.find<NavDrawerController>().deleteUser();

    Get.find<LoginRepo>().sharedPreferences.setString(SharedPreferenceHelper.accessTokenKey,'');
    Get.find<LoginRepo>().sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey,false);
    Get.find<LoginRepo>().sharedPreferences.setString(SharedPreferenceHelper.accessTokenType,'');

  }

  // Widget buildHeader(
  //   BuildContext context, {
  //   required String urlImage,
  //   required String name,
  //   required String email,
  //   bool isGuest = false,
  // }) =>
  //     Material(
  //       color:isGuest?MyColor.secondaryColor:MyColor.primaryColor,
  //       child: InkWell(
  //         splashColor: isGuest?MyColor.secondaryColor:MyColor.primaryColor,
  //         highlightColor: MyColor.primaryColor500,
  //         onTap: () => selectItem(1, NavigationItem.profileSetting),
  //         child: Column(
  //           children: [
  //             Align(
  //               alignment: Alignment.topRight,
  //               child: GestureDetector(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: Container(
  //                       padding: const EdgeInsets.only(left: 12, right: 5, bottom: 12,top: 5),
  //                       decoration: BoxDecoration(
  //                           color: /*isGuest? Colors.transparent :*/ MyColor.primaryColor350,
  //                           borderRadius: const  BorderRadius.only(bottomLeft: Radius.circular(30))),
  //                       child: const Icon(
  //                         Icons.clear,
  //                         color: MyColor.colorWhite,
  //                       ))),
  //             ),
  //             isGuest? const AuthImageWidget() :
  //             Container(
  //               padding: const EdgeInsets.only(left: 25, right: 20, bottom: 20),
  //               child: Row(
  //                 children: [
  //                   CircleAvatar(radius: 30, backgroundImage: AssetImage(urlImage)),
  //                   const SizedBox(width: 20),
  //                   Flexible(
  //                     child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         name.tr,
  //                         style: mulishSemiBold.copyWith(fontSize: Dimensions.fontLarge, color: MyColor.colorWhite),
  //                       ),
  //                       const SizedBox(height: 4),
  //                       Text(
  //                         email.tr,
  //                         style: mulishMedium.copyWith(color: MyColor.colorWhite),
  //                       ),
  //                     ],
  //                   )),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );


  Widget buildHeader(
      BuildContext context, {
        required String urlImage,
        required String name,
        required String email,
      }) =>
      Material(
        color: MyColor.primaryColor,
        child: InkWell(
          splashColor: MyColor.primaryColor,
          highlightColor: MyColor.primaryColor500,
          onTap: () => selectItem(1, NavigationItem.profileSetting),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        padding: const EdgeInsets.only(left: 12, right: 5, bottom: 12,top: 5),
                        decoration: BoxDecoration(
                            color: /*isGuest? Colors.transparent :*/ MyColor.primaryColor350,
                            borderRadius: const  BorderRadius.only(bottomLeft: Radius.circular(30))),
                        child: const Icon(
                          Icons.clear,
                          color: MyColor.colorWhite,
                        ))),
              ),
              // const AuthImageWidget() :
              Container(
                padding: const EdgeInsets.only(left: 25, right: 20, bottom: 20),
                child: Row(
                  children: [
                    CircleAvatar(radius: 30, backgroundImage: AssetImage(urlImage)),
                    const SizedBox(width: 20),
                    Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name.tr,
                              style: mulishSemiBold.copyWith(fontSize: Dimensions.fontLarge, color: MyColor.colorWhite),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email.tr,
                              style: mulishMedium.copyWith(color: MyColor.colorWhite),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      );


}
