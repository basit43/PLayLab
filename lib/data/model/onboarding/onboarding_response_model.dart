import '../auth/registration_response_model.dart';

// class OnboardingResponseModel {
//   OnboardingResponseModel({
//       String? remark,
//       String? status,
//      Message? message,
//       Data? data,}){
//     _remark = remark;
//     _status = status;
//     _message = message;
//     _data = data;
// }
//
//   OnboardingResponseModel.fromJson(dynamic json) {
//     _remark = json['remark'];
//     _status = json['status'].toString();
//     _message = json['message'] != null ? Message.fromJson(json['message']):null;
//     _data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }
//   String? _remark;
//   String? _status;
//   Message? _message;
//   Data? _data;
//
//   String? get remark => _remark;
//   String? get status => _status;
//   Message? get message => _message;
//   Data? get data => _data;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['remark'] = _remark;
//     map['status'] = _status;
//    if(_message!=null){
//       map['message'] = _message?.toJson();
//     }
//     if (_data != null) {
//       map['data'] = _data?.toJson();
//     }
//     return map;
//   }
//
// }
//
// class Data {
//   Data({
//       Welcome? welcome,
//       String? path,}){
//     _welcome = welcome;
//     _path = path;
// }
//
//   Data.fromJson(dynamic json) {
//     _welcome = json['welcome'] != null ? Welcome.fromJson(json['welcome']) : null;
//     _path = json['path'];
//   }
//   Welcome? _welcome;
//   String? _path;
//
//   Welcome? get welcome => _welcome;
//   String? get path => _path;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (_welcome != null) {
//       map['welcome'] = _welcome?.toJson();
//     }
//     map['path'] = _path;
//     return map;
//   }
//
// }
//
// class Welcome {
//   Welcome({
//       String? hasImage,
//       String? screen1Heading,
//       String? screen1Subheading,
//       String? screen2Heading,
//       String? screen2Subheading,
//       String? screen3Heading,
//       String? screen3Subheading,
//       String? backgroundImage,}){
//     _hasImage = hasImage;
//     _screen1Heading = screen1Heading;
//     _screen1Subheading = screen1Subheading;
//     _screen2Heading = screen2Heading;
//     _screen2Subheading = screen2Subheading;
//     _screen3Heading = screen3Heading;
//     _screen3Subheading = screen3Subheading;
//     _backgroundImage = backgroundImage;
// }
//
//   Welcome.fromJson(dynamic json) {
//     _hasImage = json['has_image'];
//     _screen1Heading = json['screen_1_heading'];
//     _screen1Subheading = json['screen_1_subheading'];
//     _screen2Heading = json['screen_2_heading'];
//     _screen2Subheading = json['screen_2_subheading'];
//     _screen3Heading = json['screen_3_heading'];
//     _screen3Subheading = json['screen_3_subheading'];
//     _backgroundImage = json['background_image'];
//   }
//   String? _hasImage;
//   String? _screen1Heading;
//   String? _screen1Subheading;
//   String? _screen2Heading;
//   String? _screen2Subheading;
//   String? _screen3Heading;
//   String? _screen3Subheading;
//   String? _backgroundImage;
//
//   String? get hasImage => _hasImage;
//   String? get screen1Heading => _screen1Heading;
//   String? get screen1Subheading => _screen1Subheading;
//   String? get screen2Heading => _screen2Heading;
//   String? get screen2Subheading => _screen2Subheading;
//   String? get screen3Heading => _screen3Heading;
//   String? get screen3Subheading => _screen3Subheading;
//   String? get backgroundImage => _backgroundImage;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['has_image'] = _hasImage;
//     map['screen_1_heading'] = _screen1Heading;
//     map['screen_1_subheading'] = _screen1Subheading;
//     map['screen_2_heading'] = _screen2Heading;
//     map['screen_2_subheading'] = _screen2Subheading;
//     map['screen_3_heading'] = _screen3Heading;
//     map['screen_3_subheading'] = _screen3Subheading;
//     map['background_image'] = _backgroundImage;
//     return map;
//   }
//
// }

class OnboardingResponseModel {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  OnboardingResponseModel({this.remark, this.status, this.message, this.data});

  OnboardingResponseModel.fromJson(Map<String, dynamic> json) {
    remark = json['remark'];
    status = json['status'];
    message =
    (json['message'] != null ? new Message.fromJson(json['message']) : null)!;
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['remark'] = this.remark;
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message;
    }
    if (this.data != null) {
      data['data'] = this.data;
    }
    return data;
  }
}

class Message {
  List<String>? success;

  Message({this.success});

  Message.fromJson(Map<String, dynamic> json) {
    success = json['success'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    return data;
  }
}

class Data {
  Welcome? welcome;
  String? path;

  Data({this.welcome, this.path});

  Data.fromJson(Map<String, dynamic> json) {
    welcome =
    json['welcome'] != null ? new Welcome.fromJson(json['welcome']) : null;
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.welcome != null) {
      data['welcome'] = this.welcome;
    }
    data['path'] = this.path;
    return data;
  }
}

class Welcome {
  String? hasImage;
  String? screen1Heading;
  String? screen1Subheading;
  String? screen2Heading;
  String? screen2Subheading;
  String? screen3Heading;
  String? screen3Subheading;
  String? backgroundImage;
  String? background2Image;
  String? background3Image;

  Welcome(
      {this.hasImage,
        this.screen1Heading,
        this.screen1Subheading,
        this.screen2Heading,
        this.screen2Subheading,
        this.screen3Heading,
        this.screen3Subheading,
        this.backgroundImage,
        this.background2Image,
        this.background3Image});

  Welcome.fromJson(Map<String, dynamic> json) {
    hasImage = json['has_image'];
    screen1Heading = json['screen_1_heading'];
    screen1Subheading = json['screen_1_subheading'];
    screen2Heading = json['screen_2_heading'];
    screen2Subheading = json['screen_2_subheading'];
    screen3Heading = json['screen_3_heading'];
    screen3Subheading = json['screen_3_subheading'];
    backgroundImage = json['background_image'];
    background2Image = json['background_2_image'];
    background3Image = json['background_3_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['has_image'] = this.hasImage;
    data['screen_1_heading'] = this.screen1Heading;
    data['screen_1_subheading'] = this.screen1Subheading;
    data['screen_2_heading'] = this.screen2Heading;
    data['screen_2_subheading'] = this.screen2Subheading;
    data['screen_3_heading'] = this.screen3Heading;
    data['screen_3_subheading'] = this.screen3Subheading;
    data['background_image'] = this.backgroundImage;
    data['background_2_image'] = this.background2Image;
    data['background_3_image'] = this.background3Image;
    return data;
  }
}