import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl;

  UserService({required this.baseUrl});

  Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    final response = await http.get(Uri.parse('\$baseUrl/users/\$userId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  Future<List<dynamic>> fetchUserVideos(String userId) async {
    final response = await http.get(Uri.parse('\$baseUrl/users/\$userId/videos'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user videos');
    }
  }

  Future<bool> followUser(String userId, bool follow) async {
    final response = await http.post(
      Uri.parse('\$baseUrl/users/\$userId/follow'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'follow': follow}),
    );
    return response.statusCode == 200;
  }
}
