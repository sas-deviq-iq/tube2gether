import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/auth_provider.dart';
import 'room_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _roomCodeController = TextEditingController();
  List<dynamic> publicRooms = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPublicRooms();
  }

  Future<void> _fetchPublicRooms() async {
    try {
      final response = await http.get(Uri.parse('http://158.220.120.204:3001/api/rooms/public'));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            publicRooms = jsonDecode(response.body);
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Failed to fetch rooms: $e');
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B12), 
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchPublicRooms,
          color: const Color(0xFFA259FF),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildQuickActions(),
                      const SizedBox(height: 32),
                      _buildActivePublicRooms(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFA259FF), Color(0xFFFF2D55)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.radio_button_checked, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 8),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFC084FC), Color(0xFFF472B6)],
                ).createShader(bounds),
                child: Text(
                  'Tube2Gether',
                  style: GoogleFonts.rajdhani(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    letterSpacing: -0.3,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2A),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFA259FF).withOpacity(0.15)),
                    ),
                    child: const Icon(Icons.notifications_none, color: Color(0xFFC4C4D8), size: 17),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF2D55),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Color(0xFFFF2D55), blurRadius: 6)],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 12),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFA259FF), width: 2),
                  image: DecorationImage(
                    image: NetworkImage(
                      context.watch<AuthProvider>().user?.avatarUrl ?? 
                      'https://i.pravatar.cc/150?img=11'
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/create');
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFA259FF).withOpacity(0.28)),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFA259FF).withOpacity(0.22),
                  const Color(0xFFFF2D55).withOpacity(0.1)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFA259FF), Color(0xFF7C3AED)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Create a Room', style: TextStyle(color: Color(0xFFF0F0F8), fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFA259FF).withOpacity(0.25),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFA259FF).withOpacity(0.35)),
                            ),
                            child: const Text('HOST', style: TextStyle(color: Color(0xFFC084FC), fontSize: 10, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text('Invite friends & watch together', style: TextStyle(color: Color(0xFF7A7A99), fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFFA259FF), size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF16161F),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFA259FF).withOpacity(0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('JOIN PRIVATE ROOM', style: TextStyle(color: Color(0xFF7A7A99), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E2A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFA259FF).withOpacity(0.15)),
                      ),
                      child: TextField(
                        controller: _roomCodeController,
                        style: GoogleFonts.rajdhani(color: const Color(0xFFF0F0F8), fontWeight: FontWeight.w600, letterSpacing: 1.5),
                        decoration: const InputDecoration(
                          hintText: 'Enter room code...',
                          hintStyle: TextStyle(color: Color(0xFF7A7A99)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _roomCodeController.text.length >= 4 ? null : const Color(0xFF1E1E2A),
                      gradient: _roomCodeController.text.length >= 4 ? const LinearGradient(
                        colors: [Color(0xFFA259FF), Color(0xFF7C3AED)],
                      ) : null,
                      border: _roomCodeController.text.length >= 4 ? null : Border.all(color: const Color(0xFFA259FF).withOpacity(0.15)),
                    ),
                    child: Icon(Icons.arrow_forward, size: 18, color: _roomCodeController.text.length >= 4 ? Colors.white : const Color(0xFF7A7A99)),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivePublicRooms() {
    if (isLoading) {
      return const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator(color: Color(0xFFA259FF))));
    }
    if (publicRooms.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No active public rooms right now.\nBe the first to create one!', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF7A7A99))),
        ),
      );
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 6, height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF2D55), shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Color(0xFFFF2D55), blurRadius: 6)],
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Active Public Rooms', style: TextStyle(color: Color(0xFFF0F0F8), fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            const Text('See all', style: TextStyle(color: Color(0xFFA259FF), fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: publicRooms.map((room) {
            final roomId = room['roomId'];
            final host = room['host'];
            final title = 'Room: $roomId'; 
            final viewers = room['usersCount'] ?? 0;
            final currentVideo = room['currentVideo'];
            final isLive = currentVideo != null;
            
            String thumbnailUrl = 'https://images.unsplash.com/photo-1516280440502-6c1724017772?w=800&q=80';
            if (isLive) {
              final regExp = RegExp(r'.*(?:youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*');
              final match = regExp.firstMatch(currentVideo);
              if (match != null && match.group(1)?.length == 11) {
                thumbnailUrl = 'https://img.youtube.com/vi/${match.group(1)}/maxresdefault.jpg';
              }
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF16161F),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFA259FF).withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 128,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      image: DecorationImage(image: NetworkImage(thumbnailUrl), fit: BoxFit.cover),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, const Color(0xFF0B0B12).withOpacity(0.95)],
                              begin: Alignment.topCenter, end: Alignment.bottomCenter,
                              stops: const [0.3, 1.0],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10, left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isLive ? const Color(0xFFFF2D55).withOpacity(0.9) : Colors.black.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                if (isLive) ...[
                                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                                  const SizedBox(width: 4),
                                ],
                                Text(isLive ? 'LIVE' : 'UPCOMING', style: TextStyle(color: isLive ? Colors.white : const Color(0xFF7A7A99), fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10, right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.people_outline, size: 10, color: Color(0xFFA259FF)),
                                const SizedBox(width: 4),
                                Text('$viewers', style: const TextStyle(color: Color(0xFFF0F0F8), fontSize: 10, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: const TextStyle(color: Color(0xFFF0F0F8), fontSize: 14, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 2),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Color(0xFF7A7A99), fontSize: 12),
                                  children: [
                                    const TextSpan(text: 'by '),
                                    TextSpan(text: '@${host?['username'] ?? 'Unknown'}', style: const TextStyle(color: Color(0xFFC084FC))),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen(
                              roomId: roomId,
                              initialVideoUrl: room['currentVideo'] ?? '',
                              isPublic: true,
                            )));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFFA259FF), Color(0xFF7C3AED)]),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('Join Room', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
