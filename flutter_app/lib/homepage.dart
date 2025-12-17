// flutter_app/lib/homepage.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'chat_history.dart';
import 'journal-page.dart';
import 'journal_service.dart';
import 'chat_service.dart';
import 'chat_page.dart';
import 'writing_journal_page.dart';
import 'widgets/custom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required String title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final JournalService _journalService = JournalService();
  final ChatService _chatService = ChatService(); // Use new ChatService

  List<dynamic> recentChats = [];
  List<dynamic> recentJournals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final chats = await _chatService.getChatHistory();
      final journals = await _journalService.getJournals();

      if (mounted) {
        setState(() {
          recentChats = chats.take(1).toList(); // Ambil 1 terbaru
          recentJournals = journals.take(1).toList(); // Ambil 1 terbaru
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching home data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // --- Helpers ---
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  void _handleNavigation(BuildContext context, int index) {
    if (index == 0) return;
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const ChatHistoryScreen(title: 'Riwayat Curhat')),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const JournalPage(title: 'Jurnal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7D9C4),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _fetchData,
                color: const Color(0xFFA3C4A0), // Match theme
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(), // Ensure scroll even if content is short
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Header Section ---
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFFFFFFF), width: 3),
                            ),
                            child: const CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('assets/images/foto_profile_example.jpg'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hai Orang Baik,',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Jangan lupa untuk tersenyum ya!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // --- Curhatan Section ---
                      const Text(
                        'Curhatan kamu baru baru ini!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Recent Chat Item
                      recentChats.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Text(
                                  'Masih kosong nih...',
                                  style: TextStyle(color: Color(0xFF555555), fontSize: 16),
                                ),
                              ),
                            )
                          : _buildRecentChatCard(recentChats.first),

                      const SizedBox(height: 24),

                      // --- Jurnal Section ---
                      const Text(
                        'Jurnal kamu akhir-akhir ini!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Recent Journal Item
                      recentJournals.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Text(
                                  'Masih kosong nih...',
                                  style: TextStyle(color: Color(0xFF555555), fontSize: 16),
                                ),
                              ),
                            )
                          : _buildRecentJournalCard(recentJournals.first),

                      const SizedBox(height: 24),

                      // --- Rekomendasi Section ---
                      const Text(
                        'Rekomendasi konsultasi!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildConsultationCard(
                                imagePath: 'assets/images/Logo_Halodoc.png',
                                buttonColor: const Color(0xFFE0004D),
                                onTap: () => _launchURL('https://www.halodoc.com/'),
                              ),
                              const SizedBox(width: 12),
                              _buildConsultationCard(
                                imagePath: 'assets/images/logo_Kalm.png',
                                buttonColor: const Color(0xFF5C7C8A),
                                onTap: () => _launchURL('https://www.kalm.id/'),
                              ),
                              const SizedBox(width: 12),
                              _buildConsultationCard(
                                imagePath: 'assets/images/alodokter.png',
                                buttonColor: const Color(0xFF2D74C4),
                                onTap: () => _launchURL('https://www.alodokter.com/'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
      extendBody: true,
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 0,
        onItemTapped: (index) => _handleNavigation(context, index),
      ),
    );
  }

  Widget _buildRecentChatCard(dynamic chat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  chat['title'] ?? "Tanpa Judul",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            chat['preview'] ?? "...",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 12),
          Align(
             alignment: Alignment.centerRight,
             child: ElevatedButton(
               onPressed: () {
                 // Navigasi ke ChatPage detail
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        title: chat['title'] ?? "Curhat Lama",
                        sessionId: chat['id'],
                      ),
                    ),
                 ).then((_) => _fetchData());
               },
               style: ElevatedButton.styleFrom(
                 backgroundColor: const Color(0xFFA3C4A0),
                 minimumSize: const Size(100, 36),
               ),
               child: const Text("Lanjutkan", style: TextStyle(color: Colors.white)),
             ), 
          )
        ],
      ),
    );
  }

  Widget _buildRecentJournalCard(dynamic journal) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            journal['title'] ?? 'No Title',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
           const SizedBox(height: 8),
           Text(
             journal['content'] ?? '',
             maxLines: 2,
             overflow: TextOverflow.ellipsis,
             style: const TextStyle(color: Colors.grey, fontSize: 14),
           ),
           const SizedBox(height: 12),
           Align(
             alignment: Alignment.centerRight,
             child: ElevatedButton(
               onPressed: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => WritingJournalPage(journal: journal),
                   ),
                 ).then((_) => _fetchData());
               },
               style: ElevatedButton.styleFrom(
                 backgroundColor: const Color(0xFFA3C4A0),
                 minimumSize: const Size(100, 36),
               ),
               child: const Text("Lanjutkan", style: TextStyle(color: Colors.white)),
             ), 
          )
        ],
      ),
    );
  }



  Widget _buildConsultationCard({
    required String imagePath,
    required Color buttonColor,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 120,
      height: 160,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(11),
                  bottomRight: Radius.circular(11),
                ),
              ),
              child: const Text(
                'Hubungi\nSekarang!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
