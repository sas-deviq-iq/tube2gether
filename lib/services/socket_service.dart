import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/foundation.dart';

class SocketService {
  static const String baseUrl = 'http://158.220.120.204:3001';
  io.Socket? _socket;

  io.Socket? get socket => _socket;

  void connect(String token) {
    if (_socket != null && _socket!.connected) return;

    _socket = io.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': token},
    });

    _socket!.connect();

    _socket!.onConnect((_) {
      debugPrint('Connected to Socket.IO Server');
    });

    _socket!.onConnectError((err) {
      debugPrint('Socket Connection Error: $err');
    });

    _socket!.onDisconnect((_) {
      debugPrint('Disconnected from Socket.IO Server');
    });
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
  }

  void joinRoom(String roomId, bool isPublic, String videoUrl) {
    if (_socket != null) {
      _socket!.emit('join_room', {
        'roomId': roomId,
        'isPublic': isPublic,
        'videoUrl': videoUrl,
      });
    }
  }

  void updateVideoState(String roomId, String state, double time) {
    if (_socket != null) {
      _socket!.emit('video_state_update', {
        'roomId': roomId,
        'state': state,
        'time': time,
      });
    }
  }

  void seekVideo(String roomId, double time) {
    if (_socket != null) {
      _socket!.emit('video_seek', {
        'roomId': roomId,
        'time': time,
      });
    }
  }

  void changeVideo(String roomId, String videoUrl) {
    if (_socket != null) {
      _socket!.emit('change_video', {
        'roomId': roomId,
        'videoUrl': videoUrl,
      });
    }
  }

  void sendMessage(String roomId, String message) {
    if (_socket != null) {
      _socket!.emit('send_message', {
        'roomId': roomId,
        'message': message,
      });
    }
  }
}

