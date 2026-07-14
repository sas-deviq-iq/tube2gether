import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifInvites = true;
  bool notifMessages = true;
  bool notifRoomStart = false;
  bool publicProfile = true;
  bool showActivity = true;
  bool darkMode = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notifInvites = prefs.getBool('notifInvites') ?? true;
      notifMessages = prefs.getBool('notifMessages') ?? true;
      notifRoomStart = prefs.getBool('notifRoomStart') ?? false;
      publicProfile = prefs.getBool('publicProfile') ?? true;
      showActivity = prefs.getBool('showActivity') ?? true;
      darkMode = prefs.getBool('darkMode') ?? true;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature will be available soon!'),
        backgroundColor: const Color(0xFFA259FF),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
                  children: [
                    _buildProfileCard(),
                    const SizedBox(height: 20),
                    _buildSection(
                      title: 'ACCOUNT',
                      children: [
                        _buildSettingsRow(icon: Icons.person_outline, label: 'Edit Profile', sub: 'Name, bio, avatar', iconColor: const Color(0xFFA259FF), iconBg: const Color(0xFFA259FF).withOpacity(0.12), onTap: () => _showComingSoon('Edit Profile')),
                        _buildDivider(),
                        _buildSettingsRow(icon: Icons.key, label: 'Change Password', sub: 'Update your password', iconColor: const Color(0xFF0EA5E9), iconBg: const Color(0xFF0EA5E9).withOpacity(0.12), onTap: () => _showComingSoon('Change Password')),
                        _buildDivider(),
                        _buildSettingsRow(icon: Icons.mail_outline, label: 'Email Address', sub: 'alex@example.com', iconColor: const Color(0xFF10B981), iconBg: const Color(0xFF10B981).withOpacity(0.12), onTap: () => _showComingSoon('Email Settings')),
                        _buildDivider(),
                        _buildSettingsRow(icon: Icons.g_mobiledata, label: 'Google Account', sub: 'Connected', iconColor: const Color(0xFFF59E0B), iconBg: const Color(0xFFF59E0B).withOpacity(0.12), onTap: () => _showComingSoon('Google Account')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      title: 'NOTIFICATIONS',
                      children: [
                        _buildSettingsRow(icon: Icons.notifications_none, label: 'Room Invites', sub: 'When someone invites you', iconColor: const Color(0xFFA259FF), iconBg: const Color(0xFFA259FF).withOpacity(0.12), isToggle: true, value: notifInvites, onToggle: (v) { setState(() => notifInvites = v); _saveSetting('notifInvites', v); }),
                        _buildDivider(),
                        _buildSettingsRow(icon: Icons.notifications_none, label: 'New Messages', sub: 'Chat activity in your rooms', iconColor: const Color(0xFFA259FF), iconBg: const Color(0xFFA259FF).withOpacity(0.12), isToggle: true, value: notifMessages, onToggle: (v) { setState(() => notifMessages = v); _saveSetting('notifMessages', v); }),
                        _buildDivider(),
                        _buildSettingsRow(icon: Icons.notifications_none, label: 'Room Starts', sub: 'When a room you joined goes live', iconColor: const Color(0xFFA259FF), iconBg: const Color(0xFFA259FF).withOpacity(0.12), isToggle: true, value: notifRoomStart, onToggle: (v) { setState(() => notifRoomStart = v); _saveSetting('notifRoomStart', v); }),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      title: 'PRIVACY',
                      children: [
                        _buildSettingsRow(icon: Icons.public, label: 'Public Profile', sub: 'Anyone can find your profile', iconColor: const Color(0xFF0EA5E9), iconBg: const Color(0xFF0EA5E9).withOpacity(0.12), isToggle: true, value: publicProfile, onToggle: (v) { setState(() => publicProfile = v); _saveSetting('publicProfile', v); }),
                        _buildDivider(),
                        _buildSettingsRow(icon: Icons.shield_outlined, label: 'Show Activity', sub: 'Let others see your watch history', iconColor: const Color(0xFF0EA5E9), iconBg: const Color(0xFF0EA5E9).withOpacity(0.12), isToggle: true, value: showActivity, onToggle: (v) { setState(() => showActivity = v); _saveSetting('showActivity', v); }),
                        _buildDivider(),
                        _buildSettingsRow(icon: Icons.lock_outline, label: 'Block List', sub: 'Manage blocked users', iconColor: const Color(0xFF0EA5E9), iconBg: const Color(0xFF0EA5E9).withOpacity(0.12), onTap: () => _showComingSoon('Block List')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      title: 'APPEARANCE',
                      children: [
                        _buildSettingsRow(icon: Icons.dark_mode_outlined, label: 'Dark Mode', sub: 'Always on for premium experience', iconColor: const Color(0xFFC084FC), iconBg: const Color(0xFFC084FC).withOpacity(0.12), isToggle: true, value: darkMode, onToggle: (v) { setState(() => darkMode = v); _saveSetting('darkMode', v); }),
                        _buildDivider(),
                        _buildSettingsRow(icon: Icons.palette_outlined, label: 'Accent Color', sub: 'Purple (default)', iconColor: const Color(0xFFC084FC), iconBg: const Color(0xFFC084FC).withOpacity(0.12), onTap: () => _showComingSoon('Accent Color')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      title: 'ABOUT',
                      children: [
                        _buildSettingsRow(icon: Icons.info_outline, label: 'App Version', sub: 'Tube2Gether v1.0.0', iconColor: const Color(0xFF7A7A99), iconBg: const Color(0xFF1E1E2A), onTap: () => _showComingSoon('Check for Updates')),
                        _buildDivider(),
                        _buildSettingsRow(icon: Icons.lock_outline, label: 'Privacy Policy', iconColor: const Color(0xFF7A7A99), iconBg: const Color(0xFF1E1E2A), onTap: () => _showComingSoon('Privacy Policy')),
                        _buildDivider(),
                        _buildSettingsRow(icon: Icons.info_outline, label: 'Terms of Service', iconColor: const Color(0xFF7A7A99), iconBg: const Color(0xFF1E1E2A), onTap: () => _showComingSoon('Terms of Service')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF16161F),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFF2D55).withOpacity(0.18)),
                      ),
                      child: _buildSettingsRow(
                        icon: Icons.logout, 
                        label: 'Sign Out', 
                        iconColor: const Color(0xFFFF2D55), 
                        iconBg: const Color(0xFFFF2D55).withOpacity(0.12), 
                        isDanger: true,
                        onTap: () => context.read<AuthProvider>().logout(),
                      ),
                    ),
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
        children: [
          Text('Settings', style: GoogleFonts.rajdhani(fontWeight: FontWeight.w700, fontSize: 20, color: const Color(0xFFF0F0F8))),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    final user = context.watch<AuthProvider>().user;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFA259FF).withOpacity(0.22)),
        gradient: LinearGradient(
          colors: [const Color(0xFFA259FF).withOpacity(0.14), const Color(0xFFFF2D55).withOpacity(0.07)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFA259FF), width: 2),
              image: DecorationImage(
                image: NetworkImage(user?.avatarUrl ?? 'https://i.pravatar.cc/150?img=11'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user?.username ?? 'Guest', style: const TextStyle(color: Color(0xFFF0F0F8), fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                const Text('Connected Account', style: TextStyle(color: Color(0xFF7A7A99), fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFFA259FF), size: 18),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: const TextStyle(color: Color(0xFF7A7A99), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF16161F),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFA259FF).withOpacity(0.1)),
          ),
          child: Column(children: children),
        )
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFFA259FF).withOpacity(0.06),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required String label,
    String? sub,
    required Color iconColor,
    required Color iconBg,
    bool isToggle = false,
    bool value = false,
    Function(bool)? onToggle,
    VoidCallback? onTap,
    bool isDanger = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (isToggle && onToggle != null) {
            onToggle(!value);
          } else if (onTap != null) {
            onTap();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, size: 18, color: isDanger ? const Color(0xFFFF2D55) : iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: TextStyle(color: isDanger ? const Color(0xFFFF2D55) : const Color(0xFFF0F0F8), fontSize: 14, fontWeight: FontWeight.w600)),
                    if (sub != null)
                      Text(sub, style: const TextStyle(color: Color(0xFF7A7A99), fontSize: 12)),
                  ],
                ),
              ),
              if (isToggle)
                Switch(
                  value: value,
                  onChanged: (v) {
                    if (onToggle != null) onToggle(v);
                  },
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFFA259FF),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFF2E2E40),
                )
              else if (!isDanger)
                const Icon(Icons.chevron_right, size: 16, color: Color(0xFF7A7A99)),
            ],
          ),
        ),
      ),
    );
  }
}
