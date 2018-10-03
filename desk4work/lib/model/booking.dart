class Booking {
  int id;
  int coWorkingId;
  int userId;
  bool confirmed;
  String beginWork;
  String endWork;
  String date;
  String createdAt;
  String updatedAt;


  Booking(
      {this.id,
        this.coWorkingId,
        this.userId,
        this.confirmed,
        this.beginWork,
        this.endWork,
        this.date,
        this.createdAt,
        this.updatedAt});

  Booking.fromJson(Map<String, dynamic> json) {
    print("new Booking $json");
    id = json['id'];
    coWorkingId = json['coworking_id'];
    userId = json['user_id'];
    confirmed = json['confirmed'];
    beginWork = json['begin_work'];
    endWork = json['end_work'];
    date = json['date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['coworking_id'] = this.coWorkingId;
    data['user_id'] = this.userId;
    data['confirmed'] = this.confirmed;
    data['begin_work'] = this.beginWork;
    data['end_work'] = this.endWork;
    data['date'] = this.date;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
