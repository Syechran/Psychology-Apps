import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'config.dart'; // Import Config
import 'package:open_file/open_file.dart'; // Import OpenFile

class ChatPage extends StatefulWidget {
  final String title;
  final String? sessionId; // Tambahkan parameter ini

  const ChatPage({
    super.key, 
    required this.title,
    this.sessionId, // Bisa null jika chat baru
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // Scroll Controller
  
  // State untuk menyimpan Session ID aktif
  String? _currentSessionId;
  
  bool _isSending = false;
  bool _isTyping = false;
  bool _isSummarizing = false;
  bool _isLoadingHistory = true;

  // Gunakan Config.baseUrl untuk keseragaman
  String get _baseUrl => Config.baseUrl;

  // Endpoint khusus sesuai request
  String get _chatEndpoint => '$_baseUrl/chat';
  String get _summaryEndpoint => '$_baseUrl/summary';
  // UPDATE: Sesuaikan dengan Backend yang baru diubah user (/api/chat/session)
  String get _sessionEndpoint => '$_baseUrl/chat/session'; 

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _currentSessionId = widget.sessionId; // Inisialisasi dari parameter
    
    // Jika membuka chat lama, ambil history pesannya
    if (_currentSessionId != null) {
      _fetchSessionMessages().then((_) => _scrollToBottom()); // Scroll after fetching history
    } else {
      _isLoadingHistory = false;
    }
  }

  // Fungsi mengambil pesan lama dari backend
  Future<void> _fetchSessionMessages() async {
    try {
      final response = await http.get(
        Uri.parse('$_sessionEndpoint/$_currentSessionId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _messages.addAll(data.map((msg) => _ChatMessage(
            text: msg['content'],
            isUser: msg['role'] == 'user',
          )).toList());
          _isLoadingHistory = false;
        });
      } else {
        setState(() => _isLoadingHistory = false);
      }
    } catch (e) {
      debugPrint("Error loading chat: $e");
      setState(() => _isLoadingHistory = false);
    }
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _inputController.clear();
      _isSending = true;
      _isTyping = true;
    });

    _scrollToBottom(); // Scroll after user sends

    try {
      final response = await http.post(
        Uri.parse(_chatEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': text,
          'sessionId': _currentSessionId, // PENTING: Kirim ID sesi!
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        
        // Simpan Session ID yang dikembalikan backend (untuk chat baru)
        if (_currentSessionId == null && data['sessionId'] != null) {
          _currentSessionId = data['sessionId'];
        }

        final reply = (data['reply'] ?? '').toString();
        if (reply.isNotEmpty) {
          setState(() {
            _messages.add(_ChatMessage(text: reply, isUser: false));
          });
          _scrollToBottom(); // Scroll after AI replies
        }
      } else {
        setState(() {
          _messages.add(
            const _ChatMessage(
              text: 'Maaf, terjadi kesalahan pada server.',
              isUser: false,
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(
          _ChatMessage(
            // UPDATE: Tampilkan error asli untuk debugging
            text: 'Gagal terhubung: $e', 
            isUser: false,
          ),
        );
      });
    } finally {
      if (mounted) {
      if (mounted) {
        setState(() {
          _isSending = false;
          _isTyping = false;
        });
        _scrollToBottom(); // Scroll finally to ensure everything is visible
      }
      }
    }
  }

  // ... imports


  // ... (inside _ChatPageState)

  Future<void> _downloadSummaryPdf() async {
    if (_messages.isEmpty || _isSummarizing) return;

    // 1. Tampilkan Dialog Konfirmasi
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Buat Ringkasan?"),
        content: const Text(
          "Sana akan menganalisis percakapan ini DAN jurnal 7 hari terakhir untuk membuat ringkasan kesehatan mental Anda.\n\nApakah Anda ingin melanjutkan?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFE3838),
              foregroundColor: Colors.white,
            ),
            child: const Text("Buat Summary"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // 2. Tampilkan Loading Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(color: Color(0xFFFE3838)),
              SizedBox(height: 16),
              Text(
                "Sedang menganalisis...",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Mohon tunggu sebentar, Sana sedang membaca jurnal dan chat kamu.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );

    setState(() {
      _isSummarizing = true;
    });

    try {
      final history = _messages.map((m) => m.text).toList();

      final uri = Uri.parse(_summaryEndpoint);
      final request = http.Request('POST', uri)
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({'history': history});

      final streamedResponse = await request.send();

      // Tutup Loading Dialog
      if (mounted) Navigator.pop(context);

      if (streamedResponse.statusCode == 200) {
        final bytes = await streamedResponse.stream.toBytes();

        final Directory dir = await getApplicationDocumentsDirectory();
        // Gunakan timestamp untuk nama file unik
        final String filePath =
            '${dir.path}/summary_${DateTime.now().millisecondsSinceEpoch}.pdf';

        final file = File(filePath);
        await file.writeAsBytes(bytes);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF tersimpan! Membuka file...'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
        
        // 3. Auto Open File
        // Gunakan package open_file untuk membuka PDF di aplikasi default (Windows/Android)
        await OpenFile.open(filePath);

      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Gagal membuat ringkasan (kode: ${streamedResponse.statusCode})'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Tutup Loading Dialog jika belum
      if (mounted && _isSummarizing) Navigator.maybePop(context);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Gagal: ${e.toString()}'),
               backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSummarizing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose(); // Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _isLoadingHistory 
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF8E8C1),
                    Color(0xFFEEDDC8),
                    Color(0xFFF7D9C4),
                  ],
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: 16,
                      left: 16,
                      child: _BackButton(),
                    ),
                    Positioned(
                      top: 24,
                      left: 72,
                      right: 72,
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 72, 16, 140), // Increased bottom padding to 140
                      child: _messages.isEmpty
                          ? const Center(
                              child: Text(
                                'Mulai curhat ke Sana...'
                                '\nPesanmu akan muncul di sini.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController, // Attach controller
                              itemCount: _messages.length + (_isTyping ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (_isTyping && index == _messages.length) {
                                  return const _TypingBubble();
                                }
                                return _MessageBubble(message: _messages[index]);
                              },
                            ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ChatInputBar(
                              controller: _inputController,
                              isSending: _isSending,
                              onSend: _sendMessage,
                            ),
                            const SizedBox(height: 8),
                            _SummaryButton(
                              isSummarizing: _isSummarizing,
                              onTap: _downloadSummaryPdf,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  const _ChatMessage({required this.text, required this.isUser});
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final backgroundColor =
        isUser ? const Color(0xFFB7D0AF) : Colors.white.withValues(alpha: 0.9);
    final textColor = isUser ? Colors.white : Colors.black87;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft:
                isUser ? const Radius.circular(16) : const Radius.circular(4),
            bottomRight:
                isUser ? const Radius.circular(4) : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(color: textColor, fontSize: 14),
        ),
      ),
    );
  }
}

/// Circular back button with subtle shadow and custom colors.
class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      // Gunakan warna transparan untuk material,
      // sehingga hanya container di dalam yang terlihat.
      color: Colors.transparent,
      // Clip ke bentuk lingkaran agar efek ripple tetap bulat.
      shape: const CircleBorder(),
      elevation: 4, // soft shadow agar tombol selalu "menyala" / terlihat
      child: InkWell(
        // Bentuk lingkaran agar efek ripple mengikuti bentuk tombol.
        customBorder: const CircleBorder(),
        onTap: () {
          // Pop current page (bisa diganti dengan navigasi lain jika perlu)
          Navigator.of(context).maybePop();
        },
        child: Container(
          width: 44, // sedikit lebih besar agar lebih jelas terlihat
          height: 44,
          decoration: BoxDecoration(
            // Warna tetap menyala & kontras dengan background
            color: const Color(0xFFD9E4D2), // light greenish circle
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Bottom chat input bar with rounded white background and
/// a circular send button at the right side.
class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  const _ChatInputBar({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // White pill-shaped background
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            // use withValues instead of deprecated withOpacity
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Row(
        children: [
          // Expanded text field takes remaining width
          Expanded(
            child: TextField(
              controller: controller,
              // No explicit border to keep the pill look clean
              decoration: const InputDecoration(
                hintText: 'Tulis curhatanmu.....',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 8),

          /// Circular send button at right side
          _SendButton(
            enabled: !isSending,
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}

/// Circular send button with green background and white icon.
class _SendButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const _SendButton({
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Warna ketika tidak ada teks (sama seperti sekarang)
    const Color disabledColor = Color(0xFFD9E4D2);

    // Warna ketika ada teks (lebih terang / kontras)
    const Color enabledColor = Color(0xFFB7D0AF);

    final Color backgroundColor = enabled ? enabledColor : disabledColor;

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        // Hanya boleh di-tap kalau enabled = true
        onTap: enabled ? onPressed : null,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.send_rounded,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Summary button that looks like a pill with a small PDF icon
/// and text `Summary`, using your red/white palette.
class _SummaryButton extends StatelessWidget {
  final bool isSummarizing;
  final VoidCallback onTap;

  const _SummaryButton({
    required this.isSummarizing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: isSummarizing ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFE3838),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSummarizing) ...[
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf,
                    size: 19,
                    color: Color(0xFFFE3838),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              Text(
                isSummarizing ? 'Membuat summary...' : 'Summary',
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const SizedBox(
          width: 24, 
          height: 24, 
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB7D0AF)),
          ),
        ),
      ),
    );
  }
}
