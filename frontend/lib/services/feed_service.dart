import 'dart:convert';
import 'package:http/http.dart' as http;

class FeedService {
  final String baseUrl;

  FeedService({required this.baseUrl});

  Future<List<dynamic>> fetchForYouFeed() async {
    final response = await http.get(Uri.parse('\$baseUrl/feed/for-you'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load For You feed');
    }
  }

  Future<List<dynamic>> fetchFollowingFeed() async {
    final response = await http.get(Uri.parse('\$baseUrl/feed/following'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Following feed');
    }
  }
}
