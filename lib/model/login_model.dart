import 'dart:convert';

UserLoginResponseModel userLoginResponseModelFromJson(String str) =>
    UserLoginResponseModel.fromJson(json.decode(str));

String userLoginResponseModelToJson(UserLoginResponseModel data) =>
    json.encode(data.toJson());

class UserLoginResponseModel {
  UserLoginResponseModel(
      {this.userId,
      this.email,
      this.phone,
      this.nickName,
      this.avatar,
      this.selfSignature,
      this.gender,
      this.token});

  String? userId;
  String? email;
  String? phone;
  String? nickName; //昵称
  String? avatar; //头像
  String? selfSignature; //个性签名
  int? gender; //性别
  String? token;

  factory UserLoginResponseModel.fromJson(Map<String, dynamic> json) =>
      UserLoginResponseModel(
        userId: json["user_id"],
        email: json["email"],
        phone: json["phone"],
        nickName: json["nick_name"],
        avatar: json["avatar"],
        selfSignature: json["self_signature"],
        gender: json["gender"],
        token: json["accessToken"] ?? json["token"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "email": email,
        "phone": phone,
        "nick_name": nickName,
        "avatar": avatar,
        "self_signature": selfSignature,
        "gender": gender,
        "token": token,
      };
}
