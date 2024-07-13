import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_lab/constants/my_strings.dart';
import 'package:play_lab/core/helper/string_format_helper.dart';
import '../../core/utils/my_color.dart';

class CustomSnackbar {
  static showCustomSnackbar(
      {required List<String> errorList,
      required List<String> msg,
      required bool isError,
      int duration = 5}) {
    String message = '';
    if (isError) {
      if (errorList.isEmpty) {
        message = MyStrings.unKnownError.tr;
      } else {
        for (var element in errorList) {
          message = message.isEmpty
              ? '${message.tr}${element.tr}'
              : "${message.tr}\n${element.tr}";
        }
      }
      message =
          CustomValueConverter.removeQuotationAndSpecialCharacterFromString(
              message);
    } else {
      if (msg.isEmpty) {
        message = MyStrings.success.tr;
      } else {
        for (var element in msg) {
          message = message.isEmpty
              ? '${message.tr}${element.tr}'
              : "${message.tr}\n${element.tr}";
        }
      }
      message =
          CustomValueConverter.removeQuotationAndSpecialCharacterFromString(
              message);
    }
    message = message.isEmpty
        ? isError
            ? MyStrings.failedToUpdateProfile
            : MyStrings.profileUpdatedSuccessfully
        : message;
    Get.rawSnackbar(
      progressIndicatorBackgroundColor: MyColor.primaryColor,
      message: message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.red : MyColor.greenSuccessColor,
      borderRadius: 12,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(15),
      duration: Duration(seconds: duration),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static showSnackbarWithoutTitle(BuildContext context, String message,
      {Color bg = MyColor.greenSuccessColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: bg,
        content: Text(message),
      ),
    );
  }
}
