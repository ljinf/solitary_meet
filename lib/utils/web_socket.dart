import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// WebSocket 客户端封装
class WebSocketClient {
  WebSocketChannel? _webSocketChannel;
  final String _url;
  final Map<String, dynamic> _headers;
  bool _isConnected = false;
  final List<VoidCallback> _connectListeners = [];
  final List<VoidCallback> _disconnectListeners = [];
  final List<Function(dynamic)> _messageListeners = [];
  final List<Function(dynamic)> _errorListeners = [];

  /// 创建 WebSocket 客户端
  /// [url] WebSocket 服务器地址
  /// [headers] 自定义请求头
  WebSocketClient(this._url, {Map<String, dynamic> headers = const {}})
      : _headers = headers;

  /// 连接状态
  bool get isConnected => _isConnected;

  /// 连接 WebSocket 服务器
  Future<void> connect() async {
    try {
      if (_webSocketChannel != null) {
        await disconnect();
      }

      _webSocketChannel = IOWebSocketChannel.connect(_url,
          headers: _headers, connectTimeout: Duration(seconds: 5));
      _listen();
      _isConnected = true;
      _notifyConnect();
    } catch (e) {
      _handleError('Connection failed: $e');
      rethrow;
    }
  }

  /// 断开连接
  Future<void> disconnect() async {
    if (_webSocketChannel == null) return;

    try {
      await _webSocketChannel!.sink.close();
    } catch (e) {
      _handleError('Disconnection failed: $e');
    } finally {
      _webSocketChannel = null;
      _isConnected = false;
      _notifyDisconnect();
    }
  }

  /// 发送文本消息
  Future<void> sendText(String message) async {
    _assertConnected();
    try {
      _webSocketChannel!.sink.add(message);
    } catch (e) {
      _handleError('Send text failed: $e');
      rethrow;
    }
  }

  /// 发送 JSON 消息
  Future<void> sendJson(dynamic json) async {
    _assertConnected();
    try {
      _webSocketChannel!.sink.add(jsonEncode(json));
    } catch (e) {
      _handleError('Send JSON failed: $e');
      rethrow;
    }
  }

  /// 监听连接成功事件
  void onConnect(VoidCallback callback) {
    _connectListeners.add(callback);
    if (_isConnected) {
      callback();
    }
  }

  /// 监听断开连接事件
  void onDisconnect(VoidCallback callback) {
    _disconnectListeners.add(callback);
  }

  /// 监听消息事件
  void onMessage(Function(dynamic) callback) {
    _messageListeners.add(callback);
  }

  /// 监听错误事件
  void onError(Function(dynamic) callback) {
    _errorListeners.add(callback);
  }

  void _listen() {
    if (_webSocketChannel == null) return;

    _webSocketChannel!.stream.listen(
      (message) {
        _notifyMessage(message);
      },
      onError: (error) {
        _handleError(error);
      },
      onDone: () {
        _notifyDisconnect();
      },
      cancelOnError: true,
    );
  }

  void _notifyConnect() {
    for (final callback in _connectListeners) {
      callback();
    }
  }

  void _notifyDisconnect() {
    for (final callback in _disconnectListeners) {
      callback();
    }
  }

  void _notifyMessage(dynamic message) {
    for (final callback in _messageListeners) {
      callback(message);
    }
  }

  void _handleError(dynamic error) {
    for (final callback in _errorListeners) {
      callback(error);
    }
  }

  void _assertConnected() {
    if (!_isConnected) {
      throw StateError('WebSocket is not connected');
    }
  }

  void dispose() {
    disconnect();
    _connectListeners.clear();
    _disconnectListeners.clear();
    _messageListeners.clear();
    _errorListeners.clear();
  }
}
