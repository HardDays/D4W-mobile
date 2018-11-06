import 'package:desk4work/model/co_working.dart';

class Booking {
  int id;
  int coworkingId;
  int coworkingImageId;
  int userId;
  double price;
//  bool confirmed;
  String beginWork;
  String endWork;
  String date;
  String beginDate;
  String endDate;
  String createdAt;
  String updatedAt;
  CoWorking coWorking;

  bool isVisitConfirmed;
  bool isUserCanceling;
  bool isUserLeaving;
  bool isExtendPending;
  int visitorsCount;

  String visitTime;
  String leaveTime;
  int seatNumber;


  Booking(
      {this.id,
        this.coworkingId,
        this.coworkingImageId,
        this.userId,
//        this.confirmed,
        this.beginWork,
        this.endWork,
        this.date,
        this.createdAt,
        this.isVisitConfirmed,
        this.isUserCanceling,
        this.isUserLeaving,
        this.isExtendPending,
        this.visitorsCount,
        this.beginDate,
        this.endDate,
        this.visitTime,
        this.leaveTime,
        this.seatNumber,
        this.updatedAt});

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    coworkingId = json['coworking_id'];
    coworkingImageId = json['coworking_image_id'];
    userId = json['user_id'];
//    confirmed = json['confirmed'];
    beginDate = json['begin_date'];
    endDate = json['end_date'];
    date = json['date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    coWorking = CoWorking.fromJson(json['coworking']);
    var priceJson = json['price'];
    print('price json : $priceJson');
    price = double.parse(json['price'] ?? '.0') ?? .0;


    userId = json['user_id'];
    isVisitConfirmed = json['is_visit_confirmed'] ?? false;
    isUserCanceling = json['is_user_canceling'] ?? false;
    isUserLeaving = json['is_user_leaving'] ?? false;
    isExtendPending = json['is_extend_pending'] ?? false;
    visitorsCount = json['visitors_count'];
    beginDate = json['begin_date'];
    endDate = json['end_date'];
    visitTime = json['visit_time'];
    leaveTime = json['leave_time'];
    seatNumber = json['seat_number'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['coworking_id'] = this.coworkingId;
    data['coworking_image_id'] = this.coworkingImageId;
    data['user_id'] = this.userId;
//    data['confirmed'] = this.confirmed;
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
        'confirmed: $isVisitConfirmed, beginWork: $beginWork, endWork: $endWork, '
        'date: $date, beginDate: $beginDate, endDate: $endDate, '
        'createdAt: $createdAt}';
  }


}
