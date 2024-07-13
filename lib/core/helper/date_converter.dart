import 'package:intl/intl.dart';

class DateConverter {
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }

  static String formatValidityDate(String dateString){
    var inputDate=DateFormat('yyyy-MM-dd hh:mm:ss').parse(dateString);
    var outputFormat=DateFormat('dd MMM yyyy').format(inputDate);
    return outputFormat;
  }

  static String formatDepositTimeWithAmFormat(String dateString){
    var newStr = '${dateString.substring(0,10)} ${dateString.substring(11,23)}';
    DateTime dt = DateTime.parse(newStr);
     String formatedDate= DateFormat("yyyy-MM-dd").format(dt);

    return formatedDate;
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime, true).toLocal();
  }

  static String isoStringToLocalTimeOnly(String dateTime) {
    return DateFormat('hh:mm aa').format(isoStringToLocalDate(dateTime));
  }
  static String isoStringToLocalAMPM(String dateTime) {
    return DateFormat('a').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String localDateTime(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime.toUtc());
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime.toUtc());
  }

  static String convertTimeToTime(String time) {
    return DateFormat('hh:mm a').format(DateFormat('hh:mm:ss').parse(time));
  }

  static bool isDateOver(String time) {
    try{
      DateFormat format    = DateFormat('yyyy-MM-dd HH:mm:ss');
      DateTime givenDate   = format.parse(time);
      DateTime currentTime = DateTime.now();

      return givenDate.isBefore(currentTime);
    } catch(e){
      return true;
    }

  }
}