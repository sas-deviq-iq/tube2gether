import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/platform_browser_screen.dart';

class RoomScreen extends StatefulWidget {
  final String roomId;
  final String initialVideoUrl;
  final bool isPublic;

  const RoomScreen({
    super.key,
    required this.roomId,
    required this.initialVideoUrl,
    required this.isPublic,
  });

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  String? _role; 
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  double _lastTime = 0;

  String _extractVideoId(String url) {
    final regExp = RegExp(r'.*(?:youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*');
    final match = regExp.firstMatch(url);
    return (match != null && match.group(1)?.length == 11) ? match.group(1)! : 'dQw4w9WgXcQ';
  }

  @override
  void initState() {
    super.initState();
    final videoId = _extractVideoId(widget.initialVideoUrl);
    
    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
      ),
    );

    _controller.listen((event) {
      if (!_isPlayerReady && event.playerState != PlayerState.unknown) {
        _isPlayerReady = true;
      }
      _videoListener(event);
    });

    _setupSocketListeners();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final socketService = context.read<AuthProvider>().socketService;
      socketService.joinRoom(widget.roomId, widget.isPublic, widget.initialVideoUrl);
    });
  }

  void _setupSocketListeners() {
    final socket = context.read<AuthProvider>().socketService.socket;
    if (socket == null) return;

    socket.on('room_joined', (data) async {
      if (!mounted) return;
      setState(() {
        _role = data['role'];
      });
      final state = data['roomState'];
      if (state['currentVideo'] != null && state['currentVideo'] != widget.initialVideoUrl) {
        final vId = _extractVideoId(state['currentVideo']);
        _controller.loadVideoById(videoId: vId);
      }
      final time = (state['time'] as num).toDouble();
      if (state['state'] == 'playing') {
        _controller.playVideo();
      }
      _controller.seekTo(seconds: time);
    });

    socket.on('sync_video_state', (data) async {
      if (_role == 'host' || !mounted) return;
      final state = data['state'];
      final time = (data['time'] as num).toDouble();
      
      if (state == 'playing') {
        _controller.playVideo();
      } else {
        _controller.pauseVideo();
      }
      
      final currentPos = await _controller.currentTime;
      if ((currentPos - time).abs() > 2) {
        _controller.seekTo(seconds: time);
      }
    });

    socket.on('sync_video_seek', (data) {
      if (_role == 'host' || !mounted) return;
      final time = (data['time'] as num).toDouble();
      _controller.seekTo(seconds: time);
    });

    socket.on('video_changed', (data) {
      if (_role == 'host' || !mounted) return;
      final vId = _extractVideoId(data['videoUrl']);
      _controller.loadVideoById(videoId: vId);
    });

    socket.on('receive_message', (data) {
      if (!mounted) return;
      setState(() {
        messages.add(Map<String, dynamic>.from(data));
      });
      _scrollToBottom();
    });
    
    socket.on('user_joined', (data) {
      if (!mounted) return;
      setState(() {
         messages.add({'system': true, 'message': '${data['username']} joined the room'});
      });
      _scrollToBottom();
    });

    socket.on('user_left', (data) {
      if (!mounted) return;
      setState(() {
         messages.add({'system': true, 'message': '${data['username']} left the room'});
      });
      _scrollToBottom();
    });

    socket.on('room_closed', (data) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E2A),
          title: const Text('Room Closed', style: TextStyle(color: Colors.white)),
          content: const Text('The host has been away for too long, and this room has been closed.', style: TextStyle(color: Color(0xFF7A7A99))),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // pop dialog
                if (mounted) Navigator.of(context).pop(); // pop room screen
              },
              child: const Text('OK', style: TextStyle(color: Color(0xFFA259FF))),
            )
          ],
        ),
      );
    });
  }

  void _videoListener(YoutubePlayerValue event) async {
    if (_isPlayerReady && mounted && _role == 'host') {
      final socketService = context.read<AuthProvider>().socketService;
      final state = event.playerState == PlayerState.playing ? 'playing' : 'paused';
      
      try {
        final currentSecs = await _controller.currentTime;
        // Prevent spamming
        if (state != 'playing' || (currentSecs - _lastTime).abs() >= 1.0) {
           socketService.updateVideoState(widget.roomId, state, currentSecs);
           _lastTime = currentSecs;
        }
      } catch (e) {
        // ignore
      }
    }
  }

  void _sendMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;
    
    final socketService = context.read<AuthProvider>().socketService;
    socketService.sendMessage(widget.roomId, text);
    _chatController.clear();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.close();
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16161F),
        title: Text('Room: ${widget.roomId}', style: const TextStyle(fontSize: 16)),
        actions: [
          if (_role == 'host') ...[
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              tooltip: 'Change Video',
              onPressed: () async {
                final newUrl = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlatformBrowserScreen(
                      platform: 'youtube',
                      initialUrl: 'https://m.youtube.com/',
                    ),
                  ),
                );
                if (newUrl != null && newUrl is String && newUrl.isNotEmpty && mounted) {
                  final socketService = context.read<AuthProvider>().socketService;
                  socketService.changeVideo(widget.roomId, newUrl);
                  final vId = _extractVideoId(newUrl);
                  _controller.loadVideoById(videoId: vId);
                }
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Text('HOST', style: TextStyle(color: Color(0xFFFF2D55), fontWeight: FontWeight.bold)),
            ),
          ]
        ],
      ),
      body: Column(
        children: [
          YoutubePlayer(
            controller: _controller,
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                if (msg['system'] == true) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(msg['message'], style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    ),
                  );
                }
                
                final isMe = msg['userId'] == context.read<AuthProvider>().user?.id;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isMe) ...[
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(msg['avatarUrl'] ?? 'https://i.pravatar.cc/150'),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isMe ? const Color(0xFFA259FF) : const Color(0xFF1E1E2A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isMe)
                              Text(msg['username'], style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                            Text(msg['message'], style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF1E1E2A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFFA259FF),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
