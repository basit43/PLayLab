class NewCategoryResponseModel {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  NewCategoryResponseModel({this.remark, this.status, this.message, this.data});

  NewCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    remark = json['remark'];
    status = json['status'];
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['remark'] = this.remark;
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
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
  String? portraitPath;
  String? landscapePath;
  List<Categories>? categories;

  Data({this.portraitPath, this.landscapePath, this.categories});

  Data.fromJson(Map<String, dynamic> json) {
    portraitPath = json['portrait_path'];
    landscapePath = json['landscape_path'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['portrait_path'] = this.portraitPath;
    data['landscape_path'] = this.landscapePath;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  int? status;
  List<Items>? items;

  Categories({this.id, this.name, this.status, this.items});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  int? categoryId;
  int? subCategoryId;
  String? title;
  String? previewText;
  String? description;
  Team? team;
  Image? image;
  int? itemType;
  int? status;
  int? single;
  int? trending;
  int? featured;
  int? version;
  String? tags;
  String? ratings;
  int? view;
  int? isTrailer;
  String? createdAt;
  String? updatedAt;

  Items(
      {this.id,
        this.categoryId,
        this.subCategoryId,
        this.title,
        this.previewText,
        this.description,
        this.team,
        this.image,
        this.itemType,
        this.status,
        this.single,
        this.trending,
        this.featured,
        this.version,
        this.tags,
        this.ratings,
        this.view,
        this.isTrailer,
        this.createdAt,
        this.updatedAt});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    title = json['title'];
    previewText = json['preview_text'];
    description = json['description'];
    team = json['team'] != null ? new Team.fromJson(json['team']) : null;
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    itemType = json['item_type'];
    status = json['status'];
    single = json['single'];
    trending = json['trending'];
    featured = json['featured'];
    version = json['version'];
    tags = json['tags'];
    ratings = json['ratings'];
    view = json['view'];
    isTrailer = json['is_trailer'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['title'] = this.title;
    data['preview_text'] = this.previewText;
    data['description'] = this.description;
    if (this.team != null) {
      data['team'] = this.team!.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    data['item_type'] = this.itemType;
    data['status'] = this.status;
    data['single'] = this.single;
    data['trending'] = this.trending;
    data['featured'] = this.featured;
    data['version'] = this.version;
    data['tags'] = this.tags;
    data['ratings'] = this.ratings;
    data['view'] = this.view;
    data['is_trailer'] = this.isTrailer;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Team {
  String? director;
  String? producer;
  String? casts;
  String? genres;
  String? language;

  Team({this.director, this.producer, this.casts, this.genres, this.language});

  Team.fromJson(Map<String, dynamic> json) {
    director = json['director'];
    producer = json['producer'];
    casts = json['casts'];
    genres = json['genres'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['director'] = this.director;
    data['producer'] = this.producer;
    data['casts'] = this.casts;
    data['genres'] = this.genres;
    data['language'] = this.language;
    return data;
  }
}

class Image {
  String? landscape;
  String? portrait;

  Image({this.landscape, this.portrait});

  Image.fromJson(Map<String, dynamic> json) {
    landscape = json['landscape'];
    portrait = json['portrait'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['landscape'] = this.landscape;
    data['portrait'] = this.portrait;
    return data;
  }
}