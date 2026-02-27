import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_app/features/quran/presentation/pages/quran_page.dart';
import 'package:quran_app/features/more/presentation/pages/more_page.dart';
import 'package:quran_app/presentation/pages/home_page.dart';
import 'package:quran_app/presentation/pages/sholat_page.dart';
import 'package:quran_app/features/tajwid/presentation/pages/tajwid_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al-Qur\'an Digital',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF2E8B57), // SeaGreen, a nice emerald green
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF2E8B57), // Emerald Green
          secondary: Color(0xFFDAA520), // GoldenRod for gold accent
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          background: Color(0xFFF5F5F5), // A very light grey
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Roboto', // Placeholder font
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E8B57),
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF2E8B57),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF2E8B57),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2E8B57),
          secondary: Color(0xFFDAA520),
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          background: Color(0xFF121212),
          surface: Color(0xFF1E1E1E),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: 'Roboto', // Placeholder font
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1E1E1E),
          selectedItemColor: Color(0xFF2E8B57),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system, // Respect user's device theme
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Start at Quran page for now
  final List<Widget> _pages = const [
    HomePage(),
    QuranPage(),
    SholatPage(),
    TajwidPage(),
    MorePage(), // Changed from ProfilePage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensure all items are visible
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Al-Qur\'an',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mosque_outlined),
            activeIcon: Icon(Icons.mosque),
            label: 'Sholat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Tajwid',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            activeIcon: Icon(Icons.more_vert),
            label: 'Lainnya',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}