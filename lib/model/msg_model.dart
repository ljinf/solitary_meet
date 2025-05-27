class MsgModel {
  String? userId;
  String? msgId;
  String? conversationId;
  String? content;
  int? contentType; //内容类型  1文本  2图片 3音频文件  4音频文件  5实时语音  6实时视频
  int? status; //消息状态枚举，0可见 1屏蔽 2撤回
  int? seq; //消息在会话中的序列号，用于保证消息的顺序
  int? userSeq; //用户消息消息链的序列号
  int? sendTime; //发送时间
  int? isDel; //是否删除

  MsgModel(
      {this.userId,
      this.msgId,
      this.conversationId,
      this.content,
      this.contentType,
      this.status,
      this.seq,
      this.userSeq,
      this.sendTime,
      this.isDel});

  factory MsgModel.fromJson(Map<String, dynamic> data) => MsgModel(
        userId: data['user_id'],
        msgId: data['msg_id'],
        conversationId: data['conversation_id'],
        content: data['content'],
        contentType: data['content_type'],
        status: data['status'],
        seq: data['seq'] ?? 0,
        userSeq: data['user_seq'] ?? 0,
        sendTime: data['send_time'],
        isDel: data['is_del'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "msg_id": msgId,
        "conversation_id": conversationId,
        "content": content,
        "content_type": contentType,
        "status": status,
        "seq": seq,
        "user_seq": userSeq,
        "send_time": sendTime,
        "is_del": isDel,
      };
}
