import 'dart:ffi';

import 'package:solitary_meet/model/login_model.dart';
import 'package:solitary_meet/model/msg_model.dart';

class ConversationModel {
  int? conversationId;
  int? type; //会话类型枚举，0单聊 1群聊
  String? avatar; //头像
  int? lastReadSeq; //此会话用户已读的最后一条消息
  int? notifyType; //会话收到消息的提醒类型，0未屏蔽，正常提醒 1屏蔽 2强提醒
  int? isTop; //会话是否被置顶展示 0否 1是

  MsgModel? recentMsg; //最新消息
  List<UserLoginResponseModel>? userList;

  ConversationModel(
      {this.conversationId,
      this.type,
      this.avatar,
      this.lastReadSeq,
      this.notifyType,
      this.isTop,
      this.recentMsg,
      this.userList});

  factory ConversationModel.fromJson(Map<String, dynamic> data) {
    var userList = <UserLoginResponseModel>[];

    if (data['user_list'] != null) {
      List<dynamic> list = data['user_list'] as List<dynamic>;
      for (var element in list) {
        userList.add(UserLoginResponseModel.fromJson(element));
      }
    }

    return ConversationModel(
      conversationId: data['conversation_id'],
      type: data['type'],
      avatar: data['avatar'],
      lastReadSeq: data['last_read_seq'],
      notifyType: data['notify_type'],
      isTop: data['is_top'],
      recentMsg: MsgModel.fromJson(data['recent_msg']!),
      userList: userList,
    );
  }
}
