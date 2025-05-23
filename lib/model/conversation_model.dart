import 'package:solitary_meet/model/msg_model.dart';

class ConversationModel {
  String? conversationId;
  int? type; //会话类型枚举，0单聊 1群聊
  String? userId; //
  // String? friendId; //单聊的好友ID
  int? lastReadSeq; //此会话用户已读的最后一条消息
  int? notifyType; //会话收到消息的提醒类型，0未屏蔽，正常提醒 1屏蔽 2强提醒
  int? isTop; //会话是否被置顶展示 0否 1是
  int? version; //版本

  MsgModel? recentMsg; //最新消息

  ConversationModel(
      {this.conversationId,
      this.type,
      this.userId,
      this.lastReadSeq,
      this.notifyType,
      this.isTop,
      this.version});

  factory ConversationModel.fromJson(Map<String, dynamic> data) {
    return ConversationModel(
      conversationId: data['conversation_id'],
      userId: data['user_id'],
      type: data['type'],
      lastReadSeq: data['last_read_seq'],
      notifyType: data['notify_type'],
      isTop: data['is_top'],
      version: data['version'],
    );
  }

  Map<String, dynamic> toJson() => {
        "conversation_id": conversationId,
        "type": type,
        "user_id": userId,
        "last_read_seq": lastReadSeq,
        "notify_type": notifyType,
        "is_top": isTop,
        "version": version
      };
}
