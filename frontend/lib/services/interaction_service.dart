import 'dart:convert';
import 'package:http/http.dart' as http;

class InteractionService {
  final String baseUrl;

  InteractionService({required this.baseUrl});

  Future<bool> likeVideo(String videoId, bool like) async {
    final response = await http.post(
      Uri.parse('\$baseUrl/videos/\$videoId/like'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'like': like}),
    );
    return response.statusCode == 200;
  }

  Future<bool> addComment(String videoId, String comment) async {
    final response = await http.post(
      Uri.parse('\$baseUrl/videos/\$videoId/comment'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'comment': comment}),
    );
    return response.statusCode == 200;
  }

  Future<List<dynamic>> fetchComments(String videoId) async {
    final response = await http.get(Uri.parse('\$baseUrl/videos/\$videoId/comments'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load comments');
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

  Future<List<dynamic>> fetchFollowers(String userId) async {
    final response = await http.get(Uri.parse('\$baseUrl/users/\$userId/followers'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load followers');
    }
  }
}
