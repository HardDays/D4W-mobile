class User {
  int id;

  int imageId;

  String firstName;
  String lastName;
  String email;
  String phone;

  User({this.id, this.imageId, this.firstName, this.lastName, this.email, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageId = json['image_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
  }

}