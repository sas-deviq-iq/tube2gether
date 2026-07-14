import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/shell_screen.dart';
import 'screens/create_room_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tube2Gether',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFA259FF),
          secondary: Color(0xFFFF2D55),
          background: Color(0xFF0B0B12),
        ),
        scaffoldBackgroundColor: const Color(0xFF0B0B12),
        textTheme: GoogleFonts.rajdhaniTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: const Color(0xFFF0F0F8),
          displayColor: const Color(0xFFF0F0F8),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ShellScreen(),
        '/create': (context) => const CreateRoomScreen(),
      },
    );
  }
}
