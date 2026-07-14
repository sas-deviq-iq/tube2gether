import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PlatformBrowserScreen extends StatefulWidget {
  final String platform;
  final String initialUrl;

  const PlatformBrowserScreen({
    super.key,
    required this.platform,
    required this.initialUrl,
  });

  @override
  State<PlatformBrowserScreen> createState() => _PlatformBrowserScreenState();
}

class _PlatformBrowserScreenState extends State<PlatformBrowserScreen> {
  InAppWebViewController? webViewController;
  double progress = 0;
  bool _foundStream = false;

  final InAppWebViewSettings settings = InAppWebViewSettings(
    useShouldInterceptRequest: true,
    mediaPlaybackRequiresUserGesture: false,
    javaScriptEnabled: true,
    transparentBackground: true,
    userAgent: 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Mobile Safari/537.36',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16161F),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Browse ${widget.platform}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              webViewController?.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.initialUrl)),
            initialSettings: settings,
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
            shouldInterceptRequest: (controller, request) async {
              if (_foundStream) return null;

              final url = request.url.toString();
              final currentWebUrl = await controller.getUrl();
              final currentUrlStr = currentWebUrl?.toString() ?? '';
              
              // Detect YouTube Stream
              if (widget.platform.toLowerCase() == 'youtube' && url.contains('videoplayback')) {
                // Only catch if the user is actually on a video page (watch?v=)
                // This prevents catching auto-playing previews on the home screen
                if (currentUrlStr.contains('watch?v=')) {
                  _catchStream(url);
                }
              }
              // Detect Twitch/Generic Stream
              else if (url.endsWith('.m3u8') || url.endsWith('.mp4') || url.contains('.m3u8?')) {
                if (widget.platform.toLowerCase() == 'twitch' && (currentUrlStr.endsWith('twitch.tv/') || currentUrlStr.contains('/directory'))) {
                  return null; // Skip previews on twitch homepage
                }
                _catchStream(url);
              }
              return null;
            },
          ),
          if (progress < 1.0)
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFA259FF)),
            ),
          if (_foundStream)
            Container(
              color: Colors.black.withValues(alpha: 0.8),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 64),
                    const SizedBox(height: 16),
                    const Text(
                      'Video Stream Found!',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Returning to Create Room...',
                      style: TextStyle(color: Color(0xFF7A7A99), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _catchStream(String streamUrl) {
    if (_foundStream) return;
    setState(() {
      _foundStream = true;
    });

    // Short delay to show the "Found!" UI
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pop(context, streamUrl);
      }
    });
  }
}
