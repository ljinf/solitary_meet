class RelationshipModel {
  String? userId;
  String? email;
  String? phone;
  String? nickName; //昵称
  String? avatar; //头像
  int? gender; //性别
  String? remark; //别名
  int? relationshipType;
  int? createdAt;

  RelationshipModel(
      {this.userId,
      this.email,
      this.phone,
      this.nickName,
      this.avatar,
      this.gender,
      this.remark,
      this.relationshipType,
      this.createdAt});

  factory RelationshipModel.fromJson(Map<String, dynamic> data) =>
      RelationshipModel(
        userId: data["user_id"],
        email: data["email"],
        phone: data["phone"],
        nickName: data["nick_name"],
        avatar: data["avatar"],
        gender: data["gender"],
        remark: data["remark"],
        relationshipType: data["relationship_type"],
        createdAt: data["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "email": email,
        "phone": phone,
        "nick_name": nickName,
        "avatar": avatar,
        "gender": gender,
        "remark": remark,
        "relationship_type": relationshipType,
        "created_at": createdAt,
      };
}
