
import '../auth/registration_response_model.dart';

class SubscribePlanResponseModel {
  SubscribePlanResponseModel({
      String? remark, 
      String? status, 
     Message? message, 
      MainData? mainData,}){
    _remark = remark;
    _status = status;
    _message = message;
    _mainData = mainData;
}

  SubscribePlanResponseModel.fromJson(dynamic json) {
    _remark = json['remark'];
    _status = json['status'];
    _message = json['message'] != null ? Message.fromJson(json['message']):null;
    _mainData = json['data'] != null ? MainData.fromJson(json['data']) : null;
  }
  String? _remark;
  String? _status;
  Message? _message;
  MainData? _mainData;

  String? get remark => _remark;
  String? get status => _status;
  Message? get message => _message;
  MainData? get data => _mainData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['remark'] = _remark;
    map['status'] = _status;
   if(_message!=null){
      map['message'] = _message?.toJson();
    }
    if (_mainData != null) {
      map['data'] = _mainData?.toJson();
    }
    return map;
  }

}

class MainData {
  MainData({
    String?imagePath,
      Plans? plans,}){
    _plans = plans;
    _imagePath=imagePath;
}

  MainData.fromJson(dynamic json) {
    _plans = json['plans'] != null ? Plans.fromJson(json['plans']) : null;
    _imagePath = json['image_path'];
  }

  Plans? _plans;
  Plans? get plans => _plans;
  String? _imagePath;
  String? get image => _imagePath;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_plans != null) {
      map['plans'] = _plans?.toJson();
    }
    map['image_path']=_imagePath;
    return map;
  }

}

class Plans {
  Plans({
      List<Data>? data,
      dynamic nextPageUrl,
      String? total,}){
    _data = data;
    _total = total;
}

  Plans.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _nextPageUrl = json['next_page_url'].toString();
    _total = json['total'].toString();
  }

  List<Data>? _data;
  dynamic _nextPageUrl;
  String? _total;


  List<Data>? get data => _data;
  dynamic get nextPageUrl => _nextPageUrl;
  String? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['next_page_url'] = _nextPageUrl;
    map['total'] = _total;
    return map;
  }

}


class Data {
  Data({
      int? id, 
      String? name, 
      String? pricing, 
      String? duration, 
      String? description,
      String? status,
      String? image,
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _name = name;
    _pricing = pricing;
    _duration = duration;
    _status = status;
    _image = image;
    _description = description;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name']??'';
    _pricing = json['pricing']!=null?json['pricing'].toString():'';
    _duration = json['duration']!=null?json['duration'].toString():'';
    _description = json['description']!=null?json['description'].toString():'';
    _status = json['status'].toString();
    _image = json['image']!=null?json['image'].toString():'';
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  int? _id;
  String? _name;
  String? _pricing;
  String? _duration;
  String? _status;
  String? _image;
  String? _description;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;
  String? get name => _name;
  String? get pricing => _pricing;
  String? get duration => _duration;
  String? get status => _status;
  String? get image => _image;
  String? get description => _description;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['pricing'] = _pricing;
    map['duration'] = _duration;
    map['description'] = _description;
    map['status'] = _status;
    map['image'] = _image;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}