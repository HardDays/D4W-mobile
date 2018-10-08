import 'package:desk4work/model/co_working.dart';

class Booking {
  int id;
  int coworkingId;
  int coworkingImageId;
  int userId;
  int price;
  bool confirmed;
  String beginWork;
  String endWork;
  String date;
  String beginDate;
  String endDate;
  String createdAt;
  String updatedAt;
  CoWorking coWorking;

  Booking(
      {this.id,
        this.coworkingId,
        this.coworkingImageId,
        this.userId,
        this.confirmed,
        this.beginWork,
        this.endWork,
        this.date,
        this.createdAt,
        this.updatedAt});

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    coworkingId = json['coworking_id'];
    coworkingImageId = json['coworking_image_id'];
    userId = json['user_id'];
    confirmed = json['confirmed'];
    beginDate = json['begin_date'];
    endDate = json['end_date'];
    date = json['date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    coWorking = CoWorking.fromJson(json['coworking']);
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['coworking_id'] = this.coworkingId;
    data['coworking_image_id'] = this.coworkingImageId;
    data['user_id'] = this.userId;
    data['confirmed'] = this.confirmed;
    data['begin_work'] = this.beginWork;
    data['end_work'] = this.endWork;
    data['date'] = this.date;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  @override
  String toString() {
    return 'Booking{id: $id, coworkingId: $coworkingId,'
        ' coworkingImageId: $coworkingImageId, userId: $userId, price: $price, '
        'confirmed: $confirmed, beginWork: $beginWork, endWork: $endWork, '
        'date: $date, beginDate: $beginDate, endDate: $endDate, '
        'createdAt: $createdAt}';
  }


}
