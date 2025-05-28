import 'dart:convert';
import 'dart:typed_data';
import 'package:easy_event_bus/easy_event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/model/msg_model.dart';
import '../config.dart';
import '../utils/conts.dart';
import '../utils/web_socket.dart';

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
  static late WebSocketClient client;

  static ConnStatus connStatus = ConnStatus.connecting;

  //会话ID
  static Map<String, MessageCallBack> listenList = {};

  static void initSocket() async {
    _connectToWebSocket();
  }

  static void retryConnect() async {
    if (connStatus == ConnStatus.closed) {
      _connectToWebSocket();
    }
  }

  static void _connectToWebSocket() async {
    connStatus = ConnStatus.connecting;
    try {
      client = WebSocketClient(
          '$SOCKET_HOST_DEV?token=${Global.userProfile?.token}');
      client.onConnect(() {
        connStatus = ConnStatus.connected;
        debugPrint("connect success...");
        // EasyEventBus.fire('network', true);
      });
      client.onDisconnect(_onClose);
      client.onError(_onError);
      client.onMessage((data) {
        // 检查数据是否为Uint8List（二进制数据）
        if (data is Uint8List) {
          // 处理二进制数据
          // 你可以使用其他方法来解析或显示Uint8List数据
          _onMessage(utf8.decode(data));
        } else {
          // 处理文本消息（如果服务器也发送文本消息）
          // print('Received text: $data');
          _onMessage(data);
        }
      });
      //建立连接
      client.connect();

      /* // 连接到WebSocket服务器
      socket = WebSocketChannel.connect(
          Uri.parse('$SOCKET_HOST_DEV?token=${Global.userProfile?.token}'));
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
            // print('Received text: $data');
            _onMessage(data);
          }
        },
        onError: _onError,
        onDone: _onClose,
      );*/
    } catch (e) {
      debugPrint('WebSocket error: $e');
    }
  }

  static void _onMessage(dynamic msg) {
    debugPrint('Received message from server: ${msg.toString()}');
    var message = MsgModel.fromJson(jsonDecode(msg) as Map<String, dynamic>);
    // 聊天页
    listenList[message.conversationId]?.onMessage(message);
    //会话页
    listenList[conversationPage]?.onMessage(message);
  }

  static void _onClose() {
    // 连接关闭
    connStatus = ConnStatus.closed;
    close();
  }

  static void _onError(dynamic e) {
    // 处理错误
    debugPrint('WebSocket error: $e');
    connStatus = ConnStatus.closed;
    close();
  }

  static void close() {
    //关闭连接
    debugPrint('WebSocket connection closed');
    connStatus = ConnStatus.closed;
    client.dispose();
    EasyEventBus.fire('network', false);
  }

  static addListener(String convId, MessageCallBack listener) {
    listenList[convId] = listener;
    debugPrint('conn manager add listener $convId');
  }

  static remListener(String convId) {
    listenList.remove(convId);
    debugPrint('conn manager rem listener $convId');
  }

  /// 发送 JSON 消息
  static Future<void> sendJson(int msgType, dynamic json) async {
    var data = {"msg_type": msgType, "payload": jsonToUint8List(json)};
    await client.sendJson(data);
  }

  /// 将 JSON 对象转换为 Uint8List
  static Uint8List jsonToUint8List(dynamic jsonObject) {
    // 1. 将 JSON 对象编码为字符串
    String jsonString = jsonEncode(jsonObject);

    // 2. 将字符串转换为 UTF-8 编码的字节列表
    List<int> bytes = utf8.encode(jsonString);

    // 3. 将字节列表转换为 Uint8List
    return Uint8List.fromList(bytes);
  }
}
