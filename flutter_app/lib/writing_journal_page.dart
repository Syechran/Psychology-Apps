// file: lib/writing_journal_page.dart
import 'package:flutter/material.dart';
import 'journal_service.dart';

class WritingJournalPage extends StatefulWidget {
  final Map<String, dynamic>? journal;

  const WritingJournalPage({super.key, this.journal});

  @override
  State<WritingJournalPage> createState() => _WritingJournalPageState();
}

class _WritingJournalPageState extends State<WritingJournalPage> {
  final JournalService _journalService = JournalService();

  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isEditing = false;
  bool _isNew = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.journal?['title'] ?? '');
    _contentController = TextEditingController(text: widget.journal?['content'] ?? '');
    _isNew = widget.journal == null;
    _isEditing = _isNew;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    // FIX: Simpan referensi messenger SEBELUM proses async (await)
    // Ini membuat kita tidak perlu memanggil 'context' di dalam catch block
    final messenger = ScaffoldMessenger.of(context);

    if (title.isEmpty && content.isEmpty) {
      if (!_isNew) {
        await _handleDelete();
      }
      return;
    }

    try {
      if (_isNew) {
        await _journalService.createJournal(title, content);
      } else {
        await _journalService.updateJournal(widget.journal!['id'].toString(), title, content);
      }
    } catch (e) {
      // Gunakan variabel 'messenger' yang sudah disimpan di atas
      messenger.showSnackBar(
        SnackBar(content: Text('Error saving: $e')),
      );
    }
  }

  Future<void> _handleDelete() async {
    if (_isNew) return;

    // FIX: Simpan referensi messenger SEBELUM proses async
    final messenger = ScaffoldMessenger.of(context);

    try {
      await _journalService.deleteJournal(widget.journal!['id'].toString());
    } catch (e) {
      // Gunakan variabel 'messenger'
      messenger.showSnackBar(
        SnackBar(content: Text('Error deleting: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        await _handleSave();

        // Untuk navigasi, kita tetap wajib cek mounted
        if (context.mounted) {
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7D9C4),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFA1BC98)),
            onPressed: () async {
              await _handleSave();
              // Cek mounted sebelum navigasi
              if (context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isEditing ? Icons.check : Icons.edit,
                color: const Color(0xFFA1BC98),
              ),
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                enabled: _isEditing,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                decoration: const InputDecoration(
                  hintText: '[Judul]',
                  border: InputBorder.none,
                ),
              ),
              const Divider(color: Colors.grey),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  enabled: _isEditing,
                  maxLines: null,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Start writing...',
                    border: InputBorder.none,
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
