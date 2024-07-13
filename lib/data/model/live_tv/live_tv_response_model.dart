
import '../auth/registration_response_model.dart';

class LiveTvResponseModel {
  LiveTvResponseModel({
      String? remark, 
      String? status, 
     Message? message, 
      Data? data,}){
    _remark = remark;
    _status = status;
    _message = message;
    _data = data;
}

  LiveTvResponseModel.fromJson(dynamic json) {
    _remark = json['remark'];
    _status = json['status'].toString();
    _message = json['message'] != null ? Message.fromJson(json['message']):null;
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? _remark;
  String? _status;
  Message? _message;
  Data? _data;

  String? get remark => _remark;
  String? get status => _status;
  Message? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['remark'] = _remark;
    map['status'] = _status;
   if(_message!=null){
      map['message'] = _message?.toJson();
    }
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      Televisions? televisions, 
      String? imagePath,}){
    _televisions = televisions;
    _imagePath = imagePath;
}

  Data.fromJson(dynamic json) {
    _televisions = json['televisions'] != null ? Televisions.fromJson(json['televisions']) : null;
    _imagePath = json['image_path'];
  }
  Televisions? _televisions;
  String? _imagePath;

  Televisions? get televisions => _televisions;
  String? get imagePath => _imagePath;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_televisions != null) {
      map['televisions'] = _televisions?.toJson();
    }
    map['image_path'] = _imagePath;
    return map;
  }

}

class Televisions {
  Televisions({
      List<MainTelevisionModel>? data,
      dynamic nextPageUrl}){
    _data = data;
    _nextPageUrl = nextPageUrl;
}

  Televisions.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(MainTelevisionModel.fromJson(v));
      });
    }
    _nextPageUrl = json['next_page_url'];
  }

  List<MainTelevisionModel>? _data;
  dynamic _nextPageUrl;

  List<MainTelevisionModel>? get data => _data;
  dynamic get nextPageUrl => _nextPageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['next_page_url'] = _nextPageUrl;
    return map;
  }

}


class MainTelevisionModel {
  MainTelevisionModel({
      int? id, 
      String? title, 
      String? image, 
      String? url, 
      String? status, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _title = title;
    _image = image;
    _url = url;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  MainTelevisionModel.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _image = json['image'];
    _url = json['url'];
    _status = json['status'].toString();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  int? _id;
  String? _title;
  String? _image;
  String? _url;
  String? _status;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;
  String? get title => _title;
  String? get image => _image;
  String? get url => _url;
  String? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['image'] = _image;
    map['url'] = _url;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}