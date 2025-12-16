// flutter_app/lib/journal_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class JournalService {
  // Getter untuk Base URL
  String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000/api/journals';
    if (Platform.isAndroid) return 'http://10.0.2.2:3000/api/journals';
    return 'http://localhost:3000/api/journals';
  }

  // Fungsi Get All Journals (Logika Fetching dipindah ke sini)
  Future<List<dynamic>> getJournals() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load journals: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Fungsi Create Journal
  Future<void> createJournal(String title, String content) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'content': content}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create journal');
    }
  }

  // Fungsi Update Journal
  Future<void> updateJournal(String id, String title, String content) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'content': content}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update journal');
    }
  }

  // Fungsi Delete Journal
  Future<void> deleteJournal(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete journal');
    }
  }
}
