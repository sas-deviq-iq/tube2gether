import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'platform_browser_screen.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  bool isPublic = true;
  String selectedPlatform = 'youtube';
  double maxParticipants = 20;
  bool creating = false;
  bool created = false;

  final List<Map<String, dynamic>> platforms = [
    {'id': 'youtube', 'label': 'YouTube', 'icon': Icons.play_circle_fill, 'color': const Color(0xFFFF2D55), 'bg': const Color(0xFFFF2D55).withOpacity(0.12)},
    {'id': 'twitch', 'label': 'Twitch', 'icon': Icons.live_tv, 'color': const Color(0xFFA259FF), 'bg': const Color(0xFFA259FF).withOpacity(0.12)},
    {'id': 'custom', 'label': 'Custom URL', 'icon': Icons.link, 'color': const Color(0xFF0EA5E9), 'bg': const Color(0xFF0EA5E9).withOpacity(0.12)},
  ];

  void handleCreate() {
    if (_roomNameController.text.trim().isEmpty) return;
    setState(() => creating = true);
    
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) {
        setState(() {
          creating = false;
          created = true;
        });
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            // Navigate to room
            // Navigator.pushNamed(context, '/room');
            Navigator.pop(context); // Temporarily pop back to home
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B12),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildRoomNameInput(),
                    const SizedBox(height: 20),
                    _buildRoomTypeSelector(),
                    const SizedBox(height: 20),
                    _buildPlatformSelector(),
                    const SizedBox(height: 20),
                    _buildVideoUrlInput(),
                    const SizedBox(height: 20),
                    _buildMaxParticipants(),
                    const SizedBox(height: 20),
                    _buildDescriptionInput(),
                    const SizedBox(height: 32),
                    _buildCreateButton(),
                    const SizedBox(height: 40),
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
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2A),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFA259FF).withOpacity(0.15)),
              ),
              child: const Icon(Icons.arrow_back, color: Color(0xFFC4C4D8), size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Room', style: GoogleFonts.rajdhani(fontWeight: FontWeight.w700, fontSize: 20, color: const Color(0xFFF0F0F8), height: 1.0)),
              const Text('Set up your watch party', style: TextStyle(color: Color(0xFF7A7A99), fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRoomNameInput() {
    bool hasText = _roomNameController.text.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ROOM NAME *', style: TextStyle(color: Color(0xFF7A7A99), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF16161F),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: hasText ? const Color(0xFFA259FF).withOpacity(0.35) : const Color(0xFFA259FF).withOpacity(0.12)),
          ),
          child: TextField(
            controller: _roomNameController,
            maxLength: 40,
            style: const TextStyle(color: Color(0xFFF0F0F8), fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'e.g. Marvel Movie Night 🍿',
              hintStyle: TextStyle(color: Color(0xFF7A7A99)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              counterText: '', // Hide default counter
            ),
            onChanged: (val) => setState(() {}),
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text('${_roomNameController.text.length}/40', style: const TextStyle(color: Color(0xFF7A7A99), fontSize: 10)),
        )
      ],
    );
  }

  Widget _buildRoomTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ROOM TYPE', style: TextStyle(color: Color(0xFF7A7A99), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF16161F),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFA259FF).withOpacity(0.12)),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isPublic = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: isPublic ? const LinearGradient(colors: [Color(0xFFA259FF), Color(0xFF7C3AED)]) : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.public, size: 15, color: isPublic ? Colors.white : const Color(0xFF7A7A99)),
                        const SizedBox(width: 8),
                        Text('Public', style: TextStyle(color: isPublic ? Colors.white : const Color(0xFF7A7A99), fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isPublic = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: !isPublic ? const LinearGradient(colors: [Color(0xFFA259FF), Color(0xFF7C3AED)]) : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock, size: 15, color: !isPublic ? Colors.white : const Color(0xFF7A7A99)),
                        const SizedBox(width: 8),
                        Text('Private', style: TextStyle(color: !isPublic ? Colors.white : const Color(0xFF7A7A99), fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(isPublic ? "Anyone can discover and join your room" : "Only people with the room code can join", style: const TextStyle(color: Color(0xFF7A7A99), fontSize: 12)),
      ],
    );
  }

  Widget _buildPlatformSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('PLATFORM', style: TextStyle(color: Color(0xFF7A7A99), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        Row(
          children: platforms.map((p) {
            bool isSelected = selectedPlatform == p['id'];
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedPlatform = p['id']),
                child: Container(
                  margin: EdgeInsets.only(right: p == platforms.last ? 0 : 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? p['bg'] : const Color(0xFF16161F),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? p['color'] : const Color(0xFFA259FF).withOpacity(0.12), width: isSelected ? 1.5 : 1),
                  ),
                  child: Column(
                    children: [
                      Icon(p['icon'], size: 20, color: isSelected ? p['color'] : const Color(0xFF7A7A99)),
                      const SizedBox(height: 8),
                      Text(p['label'], style: TextStyle(color: isSelected ? p['color'] : const Color(0xFF7A7A99), fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _buildVideoUrlInput() {
    bool isCustom = selectedPlatform == 'custom';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('VIDEO URL', style: TextStyle(color: Color(0xFF7A7A99), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        if (!isCustom)
          GestureDetector(
            onTap: () async {
              String initUrl = selectedPlatform == 'youtube' ? 'https://m.youtube.com' : 'https://m.twitch.tv';
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlatformBrowserScreen(
                    platform: selectedPlatform,
                    initialUrl: initUrl,
                  ),
                ),
              );
              if (result != null && result is String) {
                setState(() {
                  _videoUrlController.text = result;
                });
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFA259FF), Color(0xFF7C3AED)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(selectedPlatform == 'youtube' ? Icons.play_circle_fill : Icons.live_tv, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text('Browse ${selectedPlatform == 'youtube' ? 'YouTube' : 'Twitch'} for Video', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF16161F),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFA259FF).withOpacity(0.12)),
          ),
          child: TextField(
            controller: _videoUrlController,
            style: const TextStyle(color: Color(0xFFF0F0F8), fontSize: 14),
            decoration: InputDecoration(
              hintText: isCustom ? 'Enter video URL (mp4, m3u8...)' : 'Selected video stream URL will appear here',
              hintStyle: const TextStyle(color: Color(0xFF7A7A99)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaxParticipants() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('MAX PARTICIPANTS', style: TextStyle(color: Color(0xFF7A7A99), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF16161F),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFA259FF).withOpacity(0.12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.people, size: 16, color: Color(0xFFA259FF)),
                  const SizedBox(width: 8),
                  Text('Up to ${maxParticipants.toInt()} people', style: const TextStyle(color: Color(0xFFF0F0F8), fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => maxParticipants = (maxParticipants + 5).clamp(2, 100)),
                    child: Container(
                      width: 28, height: 24,
                      decoration: BoxDecoration(color: const Color(0xFF1E1E2A), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.keyboard_arrow_up, size: 16, color: Color(0xFFA259FF)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => setState(() => maxParticipants = (maxParticipants - 5).clamp(2, 100)),
                    child: Container(
                      width: 28, height: 24,
                      decoration: BoxDecoration(color: const Color(0xFF1E1E2A), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFFA259FF)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Slider(
          value: maxParticipants,
          min: 2,
          max: 100,
          activeColor: const Color(0xFFA259FF),
          inactiveColor: const Color(0xFF1E1E2A),
          onChanged: (val) => setState(() => maxParticipants = val),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('2', style: TextStyle(color: Color(0xFF7A7A99), fontSize: 10)),
            Text('100', style: TextStyle(color: Color(0xFF7A7A99), fontSize: 10)),
          ],
        )
      ],
    );
  }

  Widget _buildDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'DESCRIPTION ',
            style: TextStyle(color: Color(0xFF7A7A99), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2),
            children: [
              TextSpan(text: '(optional)', style: TextStyle(color: Color(0xFF3A3A55), fontWeight: FontWeight.normal, letterSpacing: 0))
            ]
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF16161F),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFA259FF).withOpacity(0.12)),
          ),
          child: TextField(
            controller: _descriptionController,
            maxLength: 120,
            maxLines: 3,
            style: const TextStyle(color: Color(0xFFF0F0F8), fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'What are you watching? Let your friends know...',
              hintStyle: TextStyle(color: Color(0xFF7A7A99)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              counterText: '',
            ),
            onChanged: (val) => setState(() {}),
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text('${_descriptionController.text.length}/120', style: const TextStyle(color: Color(0xFF7A7A99), fontSize: 10)),
        )
      ],
    );
  }

  Widget _buildCreateButton() {
    bool hasName = _roomNameController.text.trim().isNotEmpty;
    return GestureDetector(
      onTap: (!hasName || creating || created) ? null : handleCreate,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: created ? null : (hasName ? null : const Color(0xFF1E1E2A)),
          gradient: created 
            ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]) 
            : (hasName ? const LinearGradient(colors: [Color(0xFFA259FF), Color(0xFF7C3AED)]) : null),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (created) ...[
              const Icon(Icons.check, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              const Text('Room Created!', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ] else if (creating) ...[
              const SizedBox(
                width: 16, height: 16,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              ),
              const SizedBox(width: 8),
              const Text('Creating...', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ] else ...[
              Icon(Icons.auto_awesome, color: hasName ? Colors.white : const Color(0xFF7A7A99), size: 16),
              const SizedBox(width: 8),
              Text('Create Room', style: TextStyle(color: hasName ? Colors.white : const Color(0xFF7A7A99), fontSize: 16, fontWeight: FontWeight.w600)),
            ]
          ],
        ),
      ),
    );
  }
}
