import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class ChatService {
  String get baseUrl => Config.baseUrl;

  // Get All Chat History
  Future<List<dynamic>> getChatHistory() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/chat/history'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load history');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Update Session Title
  Future<void> updateTitle(String sessionId, String newTitle) async {
    final response = await http.put(
      Uri.parse('$baseUrl/chat/session/$sessionId/title'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'newTitle': newTitle}),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to update title');
    }
  }

  // Delete Session
  Future<void> deleteSession(String sessionId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/chat/session/$sessionId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete session');
    }
  }
}
