import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _roomCodeController = TextEditingController();
  List<String> joinedRooms = [];

  final List<Map<String, dynamic>> publicRooms = [
    {
      'id': 'r1',
      'title': 'Chill Lofi Beats & Study',
      'host': 'alex_chill',
      'image': 'https://images.unsplash.com/photo-1516280440502-6c1724017772?w=800&q=80',
      'viewers': 124,
      'max': 500,
      'isLive': true,
      'duration': 'Live 2h'
    },
    {
      'id': 'r2',
      'title': 'Movie Night: Inception',
      'host': 'movie_buff',
      'image': 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800&q=80',
      'viewers': 8,
      'max': 10,
      'isLive': false,
      'duration': 'Starts in 10m'
    },
  ];

  void toggleJoin(String id) {
    setState(() {
      if (joinedRooms.contains(id)) {
        joinedRooms.remove(id);
      } else {
        joinedRooms.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B12), 
      body: SafeArea(
        child: SingleChildScrollView(
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
                  image: const DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/150?img=11'),
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
            bool isJoined = joinedRooms.contains(room['id']);
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
                      image: DecorationImage(image: NetworkImage(room['image']), fit: BoxFit.cover),
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
                              color: room['isLive'] ? const Color(0xFFFF2D55).withOpacity(0.9) : Colors.black.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                if (room['isLive']) ...[
                                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                                  const SizedBox(width: 4),
                                ],
                                Text(room['isLive'] ? 'LIVE' : 'UPCOMING', style: TextStyle(color: room['isLive'] ? Colors.white : const Color(0xFF7A7A99), fontSize: 10, fontWeight: FontWeight.bold)),
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
                                Text('${room['viewers']}/${room['max']}', style: const TextStyle(color: Color(0xFFF0F0F8), fontSize: 10, fontWeight: FontWeight.w600)),
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
                              Text(room['title'], style: const TextStyle(color: Color(0xFFF0F0F8), fontSize: 14, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 2),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Color(0xFF7A7A99), fontSize: 12),
                                  children: [
                                    const TextSpan(text: 'by '),
                                    TextSpan(text: '@${room['host']}', style: const TextStyle(color: Color(0xFFC084FC))),
                                    TextSpan(text: ' · ${room['duration']}'),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => toggleJoin(room['id']),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: isJoined ? const Color(0xFFA259FF).withOpacity(0.15) : null,
                              gradient: isJoined ? null : const LinearGradient(colors: [Color(0xFFA259FF), Color(0xFF7C3AED)]),
                              borderRadius: BorderRadius.circular(12),
                              border: isJoined ? Border.all(color: const Color(0xFFA259FF).withOpacity(0.3)) : null,
                            ),
                            child: Text(isJoined ? 'Watching ▶' : 'Join Room', style: TextStyle(color: isJoined ? const Color(0xFFC084FC) : Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
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
