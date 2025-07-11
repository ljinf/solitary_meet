import 'dart:convert';

UserLoginResponseModel userLoginResponseModelFromJson(String str) =>
    UserLoginResponseModel.fromJson(json.decode(str));

String userLoginResponseModelToJson(UserLoginResponseModel data) =>
    json.encode(data.toJson());

class UserLoginResponseModel {
  UserLoginResponseModel(
      {this.userId,
      this.account,
      this.accountType,
      this.nickName,
      this.avatar,
      this.background,
      this.selfSignature,
      this.gender,
      this.initInfo,
      this.token});

  String? userId;
  String? account;
  int? accountType;
  String? nickName; //昵称
  String? avatar; //头像
  String? background; //个人背景图
  String? selfSignature; //个性签名
  int? gender; //性别
  String? token;
  bool? initInfo; //是否已初始化基本信息

  factory UserLoginResponseModel.fromJson(Map<String, dynamic> json) =>
      UserLoginResponseModel(
        userId: json["user_id"],
        account: json["account"],
        accountType: json["account_type"],
        nickName: json["nick_name"],
        avatar: json["avatar"] ?? '',
        background: json["background"] ?? '',
        selfSignature: json["self_signature"] ?? '',
        gender: json["gender"],
        initInfo: json["init_info"],
        token: json["access_token"] ?? json["token"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "account": account,
        "account_type": accountType,
        "nick_name": nickName,
        "avatar": avatar,
        "background": background,
        "self_signature": selfSignature,
        "gender": gender,
        "init_info": initInfo,
        "token": token,
      };
}

class UserInfoModel {
  UserInfoModel({this.userId, this.nickName, this.avatar});

  String? userId;
  String? nickName; //昵称
  String? avatar; //头像

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        userId: json["user_id"],
        nickName: json["nick_name"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "nick_name": nickName,
        "avatar": avatar,
      };
}
