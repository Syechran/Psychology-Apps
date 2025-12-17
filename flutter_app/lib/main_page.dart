// lib/main_page.dart
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'chat_history.dart';
import 'journal-page.dart';
import 'widgets/custom_navbar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Daftar halaman utama
  final List<Widget> _pages = [
    const HomePage(title: "Beranda"),
    const ChatHistoryScreen(title: "Riwayat"),
    const JournalPage(title: "Jurnal"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gunakan Stack agar Navbar bisa mengambang di atas konten
      body: Stack(
        children: [
          // 1. Halaman yang Aktif (di belakang navbar)
          // IndexedStack menjaga state halaman agar tidak reload saat pindah tab
          IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),

          // 2. Custom Navbar (Floating di bawah)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomNavbar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}