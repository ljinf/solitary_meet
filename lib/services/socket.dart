import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/model/msg_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../config.dart';
import '../utils/conts.dart';

abstract class MessageCallBack {
  void onMessage(MsgModel msg);
}

enum ConnStatus {
  connecting, //建立连接中
  connected, //成功
  failed, //失败
  closed, //关闭
}

class ConnManager {
  static late WebSocketChannel socket;

  static ConnStatus connStatus = ConnStatus.connecting;

  //会话ID
  static Map<int, MessageCallBack> listenList = {};

  static void initSocket() async {
    connectToWebSocket();
  }

  static void connectToWebSocket() async {
    try {
      // 连接到WebSocket服务器
      socket = WebSocketChannel.connect(Uri.parse('$SOCKET_HOST_DEV?token=${Global.userProfile?.token}'));
      // 监听消息
      StreamSubscription<dynamic> subscription = socket.stream.listen(
        (data) {
          // 检查数据是否为Uint8List（二进制数据）
          if (data is Uint8List) {
            // 处理二进制数据
            // 你可以使用其他方法来解析或显示Uint8List数据
            _onMessage(utf8.decode(data));
          } else {
            // 处理文本消息（如果服务器也发送文本消息）
            print('Received text: $data');
            _onMessage(data);
          }
        },
        onError: _onError,
        onDone: _onClose,
      );
    } catch (e) {
      print('WebSocket error: $e');
    }
  }

  static void _onMessage(dynamic msg) {
    print('Received message from server: ${msg.toString()}');
    var message = MsgModel.fromJson(jsonDecode(msg) as Map<String, dynamic>);
    // 聊天页
    listenList[message.conversationId]?.onMessage(message);
    //会话页
    listenList[conversationPage]?.onMessage(message);
  }

  static void _onClose() {
    // 连接关闭
    print('WebSocket connection closed');
    connStatus = ConnStatus.closed;
  }

  static void _onError(dynamic e) {
    // 处理错误
    print('WebSocket error: $e');
    connStatus = ConnStatus.closed;
    close();
  }

  static void close() {
    //关闭连接
    socket.sink.close();
  }

  static addListener(int convId, MessageCallBack listener) {
    listenList[convId] = listener;
    print('conn manager add listener $convId');
  }

  static remListener(int convId) {
    listenList.remove(convId);
    print('conn manager rem listener $convId');
  }
}
