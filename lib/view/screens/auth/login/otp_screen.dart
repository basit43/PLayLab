import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:play_lab/constants/my_strings.dart';
import 'package:play_lab/core/utils/my_color.dart';
import 'package:play_lab/core/utils/url_container.dart';
import 'package:play_lab/view/components/buttons/rounded_button.dart';
import 'package:http/http.dart' as http;
import '../../../../data/controller/auth/login_controller.dart';
import '../../../../data/model/auth/login_response_model.dart';
import '../../../../shared_preference_class.dart';
import '../../../components/show_custom_snackbar.dart';
import '../../bottom_nav_pages/home/home_screen.dart';
import '../../splash/splash_screen.dart';

// class OtpScreen extends StatefulWidget {
//   const OtpScreen({Key? key, this.phoneNumber, this.otp}) : super(key: key);
//   final String? phoneNumber;
//   final int? otp;
//
//
//   // const OtpScreen({Key? key, this.verificationId, this.phoneNumber}) : super(key: key);
//   // final String? verificationId;
//   // final String? phoneNumber;
//
//
//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends State<OtpScreen> {
//   List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
//   late List<FocusNode> focusNodes;
//   LoginController? loginController;
//
//
//   @override
//   void initState() {
//     super.initState();
//     focusNodes = List.generate(6, (_) => FocusNode());
//     // loginController = LoginController(loginRepo: LoginRepo());
//   }
//
//   @override
//   void dispose() {
//     for (var node in focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // final loginProvider = Provider.of<OtpNotifier>(context, listen: false);
//     print("object ${widget.phoneNumber}");
//     print("kilash ${widget.otp}");
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Gap(80),
//             IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: const Icon(
//                 Icons.arrow_back,
//                 color: MyColor.t1,
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.only(left: 15.0, top: 30),
//               child: Text(
//                 'Verification',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             const Padding(
//               padding: EdgeInsets.only(left: 15.0),
//               child: Text(
//                 'Please enter the 4 digit OTP code that has been\nsent to 79******01',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: MyColor.t2,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(6, (index) {
//                 return Container(
//                   height: 50,
//                   width: 50,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     color: MyColor.t1,
//                     border: Border.all(
//                       color: const Color(0xff10A173),
//                       width: 1,
//                     ),
//                   ),
//                   child: TextFormField(
//                     controller: otpControllers[index],
//                     focusNode: focusNodes[index],
//                     textInputAction: index < 5 ? TextInputAction.next : TextInputAction.done,
//                     keyboardType: TextInputType.number,
//                     textAlign: TextAlign.center,
//                     maxLength: 1,
//                     cursorColor: MyColor.primaryColor,
//                     style: const TextStyle(color: Colors.black),
//                     onChanged: (value) {
//                       if (value.isNotEmpty && index < 5) {
//                         FocusScope.of(context).requestFocus(focusNodes[index + 1]);
//                       }
//                     },
//                     decoration: const InputDecoration(
//                       counterText: '',
//                       enabledBorder: InputBorder.none,
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: MyColor.primaryColor,
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//             const SizedBox(
//               height: 45,
//             ),
//             RoundedButton(
//                 text: MyStrings.submitOtp,
//                 press: () async{
//                   try {
//                     // String enteredOtp = otpControllers.map((controller) => controller.text).join();
//                     // PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId!, smsCode: enteredOtp);
//                     // await FirebaseAuth.instance.signInWithCredential(credential);
//
//                     print("Number ${widget.phoneNumber.toString()}");
//                     print("Otp ${widget.otp.toString()}");
//
//                     verifyOtp(widget.phoneNumber.toString(), widget.otp.toString());
//
//                     // loginUser(widget.phoneNumber.toString());
//
//                     // userLogin(widget.phoneNumber.toString());
//
//                   } catch (ex) {
//                     print(ex.toString());
//                   }
//                 }
//             ),
//
//
//
//
//             const SizedBox(
//               height: 30,
//             ),
//             const Center(
//               child: Text(
//                 'Didn\'t receive any code?',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: MyColor.t2,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Center(
//               child: TextButton(
//                 onPressed: () {
//                   // loginProvider.signInWithPhoneNumber("", context);
//                 },
//                 child: const Text(
//                   'Resend Code',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: MyColor.primaryColor,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//
//   // TODO VERIFY OTP
//   verifyOtp(String phoneNumber, String otp) async {
//     print("Asim $phoneNumber");
//     print("AsimK $otp");
//
//     try {
//       final response = await http.post(
//           Uri.parse('${UrlContainer.baseUrl}${UrlContainer.otpVerifyEndPoint}'),
//           body: {
//             "number": phoneNumber,
//             "otp": otp
//           });
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body.toString());
//         print("Data $data");
//         print("Successfully Verify");
//
//         Fluttertoast.showToast(
//             msg: "Successfully Verify",
//             backgroundColor: Colors.green,
//             textColor: Colors.white,
//             fontSize: 18);
//       } else {
//         print("Failed");
//         Fluttertoast.showToast(
//             msg: response.statusCode.toString(),
//             backgroundColor: Colors.redAccent,
//             textColor: Colors.white,
//             fontSize: 18);
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) => const SplashScreen()));
//       }
//     } catch (e) {
//       print(e.toString());
//       Fluttertoast.showToast(
//           msg: e.toString(),
//           backgroundColor: Colors.redAccent,
//           textColor: Colors.white,
//           fontSize: 18);
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (context) => const SplashScreen()));
//     }
//   }
//
//
//
//
//
//   loginUser(String phoneNumber) async {
//     print("PhoneNumber $phoneNumber");
//     // ResponseModel? model= await loginRepo.loginUser(phoneNumber);
//     // Remove the '+' from the beginning
//     String phoneNumberWithoutPlus = phoneNumber.substring(0);
//     // Now you can use phoneNumberWithoutPlus for further processing
//     print('Phone number without plus: $phoneNumberWithoutPlus');
//     final response = await http.post(
//         Uri.parse(
//             '${UrlContainer.baseUrl}${UrlContainer.loginEndPoint}'),
//         body: {
//           "mobile": phoneNumberWithoutPlus,
//         });
//     print("Response $response");
//     if(response.statusCode==200){
//       var data = jsonDecode(response.body);
//       print("Data $data");
//       LoginResponseModel loginModel = LoginResponseModel.fromJson(data);
//       MySharedPrefClass.preferences?.setBool("loggedIn", true);
//       MySharedPrefClass.preferences?.setString('name', loginModel.data!.user!.firstname.toString());
//       MySharedPrefClass.preferences?.setString('email', loginModel.data!.user!.email.toString());
//       MySharedPrefClass.preferences?.setString('token', loginModel.data!.accessToken.toString());
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
//       if(loginModel.status=='error'){
//         CustomSnackbar.showCustomSnackbar(errorList: [loginModel.message?.error?.toString()??'user login failed , pls try again'], msg: [], isError: true);
//         loginController?.changeIsLoading();
//         return;
//       }else{
//         loginController?.checkAndGotoNextStep(loginModel);
//       }
//     }
//     else{
//       print("Error");
//       // CustomSnackbar.showCustomSnackbar(errorList: [model.message], msg: [], isError: false);
//       loginController?.changeIsLoading();
//     }
//   }
//
//
//   userLogin(String phoneNumber) async {
//     print("Asim $phoneNumber");
//
//     // Remove the '+' from the beginning
//     String phoneNumberWithoutPlus = phoneNumber.substring(0);
//
//     // Now you can use phoneNumberWithoutPlus for further processing
//     print('Phone number without plus: $phoneNumberWithoutPlus');
//
//
//     try {
//       final response = await http.post(
//           Uri.parse(
//               '${UrlContainer.baseUrl}${UrlContainer.loginEndPoint}'),
//           body: {
//             "mobile": phoneNumberWithoutPlus,
//           });
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         print("Data $data");
//         LoginResponseModel loginModel = LoginResponseModel.fromJson(data);
//         print("Login Model ${loginModel.data}");
//         print("Login Successfully");
//         MySharedPrefClass.preferences!.setBool("loggedIn", true);
//         // MySharedPrefClass.preferences?.setString("Access_Token", data["token"]);
//         Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
//         Fluttertoast.showToast(
//             msg: "Login Successfully",
//             backgroundColor: Colors.green,
//             textColor: Colors.white,
//             fontSize: 18);
//       } else if (response.statusCode == 401) {
//         Fluttertoast.showToast(
//             msg: "User with this email is already exist",
//             backgroundColor: Colors.redAccent,
//             textColor: Colors.white,
//             fontSize: 18);
//       } else {
//         print("Failed");
//         Fluttertoast.showToast(
//             msg: response.statusCode.toString(),
//             backgroundColor: Colors.redAccent,
//             textColor: Colors.white,
//             fontSize: 18);
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) => const LoginScreen()));
//       }
//     } catch (e) {
//       print(e.toString());
//       Fluttertoast.showToast(
//           msg: e.toString(),
//           backgroundColor: Colors.redAccent,
//           textColor: Colors.white,
//           fontSize: 18);
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (context) => const LoginScreen()));
//     }
//   }
//
//
// }

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, this.phoneNumber, this.otp}) : super(key: key);
  final String? phoneNumber;
  final int? otp;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late TextEditingController phoneNumberController;
  late TextEditingController otpController;
  LoginController? loginController;

  @override
  void initState() {
    super.initState();
    phoneNumberController = TextEditingController(text: widget.phoneNumber);
    otpController = TextEditingController(text: widget.otp.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(80),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: MyColor.t1,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 30),
              child: Text(
                'Verification',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                'Please enter the 6 digit OTP code that has been\nsent to ${widget.phoneNumber}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: MyColor.t2,
                ),
              ),
            ),
            const SizedBox(height: 30),
            buildTextField("Mobile Number", phoneNumberController, false),
            const SizedBox(height: 10),
            buildTextField("OTP", otpController, false),
            const SizedBox(height: 45),
            RoundedButton(
              text: MyStrings.submitOtp,
              press: () async {
                try {
                  verifyOtp(widget.phoneNumber!, widget.otp.toString());
                } catch (ex) {
                  print(ex.toString());
                }
              },
            ),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                'Didn\'t receive any code?',
                style: TextStyle(
                  fontSize: 14,
                  color: MyColor.t2,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  // Resend code functionality
                },
                child: const Text(
                  'Resend Code',
                  style: TextStyle(
                    fontSize: 14,
                    color: MyColor.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, TextEditingController controller, bool enabled) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        readOnly: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: MyColor.t2),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: MyColor.t1),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: MyColor.primaryColor),
          ),
        ),
      ),
    );
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    print("Asim $phoneNumber");
    print("AsimK $otp");

    try {
      final response = await http.post(
        Uri.parse('${UrlContainer.baseUrl}${UrlContainer.otpVerifyEndPoint}'),
        body: {"number": phoneNumber, "otp": otp},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print("Data $data");
        print("Successfully Verify");

        Fluttertoast.showToast(
          msg: "Successfully Verify",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18,
        );

        // Call loginUser function after successful OTP verification
        loginUser(phoneNumber);
      } else {
        print("Failed");
        Fluttertoast.showToast(
          msg: response.statusCode.toString(),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
        );
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 18,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    }
  }

  loginUser(String phoneNumber) async {
    print("PhoneNumber $phoneNumber");
    // ResponseModel? model= await loginRepo.loginUser(phoneNumber);
    // Remove the '+' from the beginning
    String phoneNumberWithoutPlus = phoneNumber.substring(0);
    // Now you can use phoneNumberWithoutPlus for further processing
    print('Phone number without plus: $phoneNumberWithoutPlus');
    final response = await http.post(
        Uri.parse('${UrlContainer.baseUrl}${UrlContainer.loginEndPoint}'),
        body: {
          "mobile": phoneNumberWithoutPlus,
        });
    print("Response $response");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("Data $data");
      LoginResponseModel loginModel = LoginResponseModel.fromJson(data);
      MySharedPrefClass.preferences?.setBool("loggedIn", true);
      MySharedPrefClass.preferences
          ?.setString('name', loginModel.data!.user!.firstname.toString());
      MySharedPrefClass.preferences
          ?.setString('email', loginModel.data!.user!.email.toString());
      MySharedPrefClass.preferences
          ?.setString('token', loginModel.data!.accessToken.toString());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      if (loginModel.status == 'error') {
        CustomSnackbar.showCustomSnackbar(errorList: [
          loginModel.message?.error?.toString() ??
              'user login failed , pls try again'
        ], msg: [], isError: true);
        loginController?.changeIsLoading();
        return;
      } else {
        loginController?.checkAndGotoNextStep(loginModel);
      }
    } else {
      print("Error");
      loginController?.changeIsLoading();
    }
  }
}
