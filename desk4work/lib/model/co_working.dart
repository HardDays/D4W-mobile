import 'package:intl/intl.dart';

class CoWorking{
  int id;
  String fullName;
  String shortName;
  String address;
  double lat;
  double lng;
  String description;
  String contacts;
  double price;
  int capacity;
  String category;
  String subCategory;
  List<WorkingDays> workingDays;
  List<String> amenties;
  List<String> images;
  int imageId;
  int creatorId;
  String createdAt;
  String updatedAt;
  WorkingDays currentDay;

  CoWorking(
      {this.id,
        this.fullName,
        this.shortName,
        this.address,
        this.lat,
        this.lng,
        this.description,
        this.contacts,
        this.price,
        this.capacity,
        this.category,
        this.subCategory,
        this.workingDays,
        this.amenties,
        this.images,
        this.imageId,
        this.creatorId,
        this.createdAt,
        this.updatedAt});

  CoWorking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    shortName = json['short_name'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    description = json['description'];
    contacts = json['contacts'];
    price = json['price'];
    capacity = json['capacity'];
    category = json['category'];
    subCategory = json['sub_category'];
    if (json['working_days'] != null) {
      var current = DateFormat.EEEE().format(DateTime.now());
      workingDays = new List<WorkingDays>();
      json['working_days'].forEach((v) {
        var wd = WorkingDays.fromJson(v);
        workingDays.add(wd);
        if (wd.day == current){
          currentDay = wd;
        }
      });
    }
    if( json['amenties'] !=null){
      amenties = [];
      json['amenties'].forEach((k){
        amenties.add(k['name'].toString());


//        amenties[k] = s.toString();
      });
    }
    images = json['images'].cast<String>();
    imageId = json['image_id'];
    creatorId = json['creator_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['short_name'] = this.shortName;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['description'] = this.description;
    data['contacts'] = this.contacts;
    data['price'] = this.price;
    data['capacity'] = this.capacity;
    data['category'] = this.category;
    data['sub_category'] = this.subCategory;
    if (this.workingDays != null) {
      data['working_days'] = this.workingDays.map((v) => v.toJson()).toList();
    }
    data['amenties'] = this.amenties;
    data['images'] = this.images;
    data['image_id'] = this.imageId;
    data['creator_id'] = this.creatorId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class WorkingDays {
  String day;
  String beginWork;
  String endWork;

  WorkingDays({this.day, this.beginWork, this.endWork});

  WorkingDays.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    beginWork = json['begin_work'];
    endWork = json['end_work'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['begin_work'] = this.beginWork;
    data['end_work'] = this.endWork;
    return data;
  }
}