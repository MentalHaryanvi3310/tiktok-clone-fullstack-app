import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class VideoUploadService {
  final String baseUrl;

  VideoUploadService({required this.baseUrl});

  Future<bool> uploadVideo({
    required File videoFile,
    String? title,
    String? description,
  }) async {
    try {
      var uri = Uri.parse('\$baseUrl/videos/upload');
      var request = http.MultipartRequest('POST', uri);

      var videoStream = http.ByteStream(videoFile.openRead());
      var videoLength = await videoFile.length();

      var multipartFile = http.MultipartFile(
        'video',
        videoStream,
        videoLength,
        filename: path.basename(videoFile.path),
      );

      request.files.add(multipartFile);

      if (title != null) {
        request.fields['title'] = title;
      }
      if (description != null) {
        request.fields['description'] = description;
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
