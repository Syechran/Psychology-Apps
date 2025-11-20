import 'package:flutter/material.dart';

/// Chat page with gradient background, back button,
/// chat input field, send button, and summary button.
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Make the body draw behind the system status bar
      extendBodyBehindAppBar: true,
      // We do not use the default app bar because the design
      // uses a floating circular back button instead.
      body: Container(
        // Full-screen gradient background using your palette
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8E8C1), // top
              Color(0xFFEEDDC8), // middle
              Color(0xFFF7D9C4), // bottom
            ],
          ),
        ),
        // Use SafeArea so content does not overlap system UI
        child: Stack(
          children: [
            /// Positioned circular back button on top-left
            Positioned(
              // Sedikit diturunkan dari posisi sebelumnya (16 -> 32)
              top: 32,
              left: 16,
              child: _BackButton(),
            ),

            /// Bottom area with input and summary button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                // Outer padding from screen edges
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ChatInputBar(),
                    const SizedBox(height: 12),
                    _SummaryButton(),
                  ],
                ),
              ),
            ),
          ],
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
class _ChatInputBar extends StatefulWidget {
  const _ChatInputBar();

  @override
  State<_ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<_ChatInputBar> {
  // Controller untuk memantau isi text field
  final TextEditingController _controller = TextEditingController();

  // Menyimpan apakah text field kosong atau tidak
  bool _isInputNotEmpty = false;

  @override
  void initState() {
    super.initState();

    // Listener untuk update state ketika teks berubah
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _isInputNotEmpty) {
        setState(() {
          _isInputNotEmpty = hasText;
        });
      }
    });
  }

  @override
  void dispose() {
    // Buang controller ketika widget dihapus
    _controller.dispose();
    super.dispose();
  }

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
              controller: _controller,
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
            enabled: _isInputNotEmpty,
          ),
        ],
      ),
    );
  }
}

/// Circular send button with green background and white icon.
class _SendButton extends StatelessWidget {
  final bool enabled;

  const _SendButton({required this.enabled});

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
        onTap: enabled
            ? () {
                // TODO: implement send chat logic
              }
            : null,
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
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          // TODO: generate summary PDF
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFE3838), // red background
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                // use withValues instead of deprecated withOpacity
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Small rounded white PDF badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
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
              const SizedBox(width: 8),
              const Text(
                'Summary',
                style: TextStyle(
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
