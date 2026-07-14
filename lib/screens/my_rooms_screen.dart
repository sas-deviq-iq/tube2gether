import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyRoomsScreen extends StatefulWidget {
  const MyRoomsScreen({super.key});

  @override
  State<MyRoomsScreen> createState() => _MyRoomsScreenState();
}

class _MyRoomsScreenState extends State<MyRoomsScreen> {
  int activeTab = 0;
  final List<String> tabs = ['Created', 'Joined', 'Invites'];

  final List<Map<String, dynamic>> myCreatedRooms = [];
  final List<Map<String, dynamic>> myJoinedRooms = [];
  final List<Map<String, dynamic>> myInvites = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B12),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    if (activeTab == 0) ..._buildCreatedRooms(),
                    if (activeTab == 1) ..._buildJoinedRooms(),
                    if (activeTab == 2) ..._buildInvites(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            )
          ],
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
          Text('My Rooms', style: GoogleFonts.rajdhani(fontWeight: FontWeight.w700, fontSize: 22, color: const Color(0xFFF0F0F8))),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/create');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFA259FF), Color(0xFF7C3AED)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.add, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text('New Room', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF16161F),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFA259FF).withOpacity(0.1)),
        ),
        child: Row(
          children: List.generate(tabs.length, (i) {
            bool isActive = activeTab == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => activeTab = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isActive ? const LinearGradient(colors: [Color(0xFFA259FF), Color(0xFF7C3AED)]) : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Text(tabs[i], style: TextStyle(color: isActive ? Colors.white : const Color(0xFF7A7A99), fontSize: 12, fontWeight: FontWeight.w600)),
                      if (i == 2 && myInvites.isNotEmpty)
                        Positioned(
                          right: -10, top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(color: Color(0xFFFF2D55), shape: BoxShape.circle),
                            child: Text('${myInvites.length}', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  List<Widget> _buildCreatedRooms() {
    if (myCreatedRooms.isEmpty) {
      return [_buildEmptyState('You haven\'t created any rooms yet.')];
    }
    return myCreatedRooms.map((room) {
      return Container(
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF16161F),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFA259FF).withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Container(
              height: 112,
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
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10, left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFF59E0B).withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        children: [
                          Icon(Icons.star, size: 9, color: Colors.white),
                          SizedBox(width: 4),
                          Text('HOST', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10, right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: room['isLive'] ? const Color(0xFFFF2D55).withOpacity(0.9) : Colors.black.withOpacity(0.65), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          if (room['isLive']) ...[
                            Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                          ],
                          Text(room['isLive'] ? 'LIVE' : 'OFFLINE', style: TextStyle(color: room['isLive'] ? Colors.white : const Color(0xFF7A7A99), fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(room['title'], style: const TextStyle(color: Color(0xFFF0F0F8), fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(room['isPrivate'] ? Icons.lock : Icons.public, size: 10, color: const Color(0xFF7A7A99)),
                            const SizedBox(width: 2),
                            Text(room['isPrivate'] ? 'Private' : 'Public', style: const TextStyle(color: Color(0xFF7A7A99), fontSize: 10)),
                            const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('·', style: TextStyle(color: Color(0xFF3A3A55), fontSize: 10))),
                            const Icon(Icons.people_outline, size: 10, color: Color(0xFFA259FF)),
                            const SizedBox(width: 2),
                            Text('${room['viewers']}', style: const TextStyle(color: Color(0xFFA259FF), fontSize: 10)),
                            Text('/${room['max']}', style: const TextStyle(color: Color(0xFF7A7A99), fontSize: 10)),
                            const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('·', style: TextStyle(color: Color(0xFF3A3A55), fontSize: 10))),
                            const Icon(Icons.access_time, size: 10, color: Color(0xFF7A7A99)),
                            const SizedBox(width: 2),
                            Text(room['createdAt'], style: const TextStyle(color: Color(0xFF7A7A99), fontSize: 10)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: room['isLive'] ? const LinearGradient(colors: [Color(0xFFA259FF), Color(0xFF7C3AED)]) : null,
                      color: room['isLive'] ? null : const Color(0xFF1E1E2A),
                      borderRadius: BorderRadius.circular(12),
                      border: room['isLive'] ? null : Border.all(color: const Color(0xFFA259FF).withOpacity(0.15)),
                    ),
                    child: Text(room['isLive'] ? '▶ Open' : 'Start', style: TextStyle(color: room['isLive'] ? Colors.white : const Color(0xFFC4C4D8), fontSize: 12, fontWeight: FontWeight.w600)),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildJoinedRooms() {
    if (myJoinedRooms.isEmpty) {
      return [_buildEmptyState('You haven\'t joined any rooms yet.')];
    }
    return myJoinedRooms.map((room) {
      return Container(
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF16161F),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFA259FF).withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Container(
              height: 112,
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
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10, left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: room['isLive'] ? const Color(0xFFFF2D55).withOpacity(0.9) : Colors.black.withOpacity(0.65), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          if (room['isLive']) ...[
                            Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                          ],
                          Text(room['isLive'] ? 'LIVE' : 'ENDED', style: TextStyle(color: room['isLive'] ? Colors.white : const Color(0xFF7A7A99), fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10, right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.65), borderRadius: BorderRadius.circular(12)),
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
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(room['title'], style: const TextStyle(color: Color(0xFFF0F0F8), fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Color(0xFF7A7A99), fontSize: 12),
                            children: [
                              const TextSpan(text: 'by '),
                              TextSpan(text: '@${room['host']}', style: const TextStyle(color: Color(0xFFC084FC))),
                              TextSpan(text: ' · Joined ${room['joinedAt']}'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  if (room['isLive'])
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFA259FF), Color(0xFF7C3AED)]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Rejoin', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    )
                ],
              ),
            )
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildInvites() {
    if (myInvites.isEmpty) {
      return [_buildEmptyState('No pending invites.')];
    }
    return myInvites.map((invite) {
      return Container(
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF16161F),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFA259FF).withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Container(
              height: 112,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                image: DecorationImage(image: NetworkImage(invite['image']), fit: BoxFit.cover),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, const Color(0xFF0B0B12).withOpacity(0.95)],
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10, left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFA259FF).withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
                      child: const Text('INVITE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  if (invite['isPrivate'])
                    Positioned(
                      top: 10, right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.65), borderRadius: BorderRadius.circular(12)),
                        child: const Row(
                          children: [
                            Icon(Icons.lock, size: 9, color: Color(0xFFF0F0F8)),
                            SizedBox(width: 4),
                            Text('Private', style: TextStyle(color: Color(0xFFF0F0F8), fontSize: 10, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(invite['title'], style: const TextStyle(color: Color(0xFFF0F0F8), fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Color(0xFF7A7A99), fontSize: 12),
                      children: [
                        TextSpan(text: '@${invite['host']}', style: const TextStyle(color: Color(0xFFC084FC))),
                        TextSpan(text: ' invited you · ${invite['invitedAt']}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFFA259FF), Color(0xFF7C3AED)]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_forward, size: 13, color: Colors.white),
                              SizedBox(width: 6),
                              Text('Accept & Join', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFA259FF).withOpacity(0.12)),
                        ),
                        child: const Text('Decline', style: TextStyle(color: Color(0xFF7A7A99), fontSize: 12, fontWeight: FontWeight.w600)),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
    }).toList();
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 64.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64, color: const Color(0xFF7A7A99).withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(color: Color(0xFF7A7A99), fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
