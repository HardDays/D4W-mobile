class User {
  int id;

  int imageId;

  String firstName;
  String lastName;
  String email;
  String phone;
  String image;

  User({this.id, this.imageId, this.firstName, this.lastName, this.email, this.phone, this.image});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageId = json['image_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
  }

   Map<dynamic, dynamic> toJson() {
    var json = {};
    json['first_name'] = firstName;
    json['last_name'] = lastName;
    json['email'] = email;
    json['phone'] = phone;
    json['image'] = image;
    return json;
  }

}