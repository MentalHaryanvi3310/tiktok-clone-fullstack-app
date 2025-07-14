import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../services/video_upload_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final VideoUploadService _uploadService = VideoUploadService(baseUrl: 'http://localhost:3000'); // Update backend URL
  final ImagePicker _picker = ImagePicker();

  File? _videoFile;
  VideoPlayerController? _videoController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _uploading = false;
  String? _uploadMessage;

  Future<void> _pickVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 60),
    );
    if (pickedFile != null) {
      _setVideoFile(File(pickedFile.path));
    }
  }

  Future<void> _recordVideo() async {
    final XFile? recordedFile = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 60),
    );
    if (recordedFile != null) {
      _setVideoFile(File(recordedFile.path));
    }
  }

  void _setVideoFile(File file) {
    _videoFile = file;
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {});
        _videoController?.play();
        _videoController?.setLooping(true);
      });
    setState(() {});
  }

  Future<void> _uploadVideo() async {
    if (_videoFile == null) {
      setState(() {
        _uploadMessage = 'Please select or record a video first.';
      });
      return;
    }
    setState(() {
      _uploading = true;
      _uploadMessage = null;
    });
    try {
      bool success = await _uploadService.uploadVideo(
        videoFile: _videoFile!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );
      setState(() {
        _uploadMessage = success ? 'Upload successful!' : 'Upload failed.';
      });
      if (success) {
        _videoFile = null;
        _videoController?.dispose();
        _videoController = null;
        _titleController.clear();
        _descriptionController.clear();
      }
    } catch (e) {
      setState(() {
        _uploadMessage = 'Error: \$e';
      });
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Video'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_videoController != null && _videoController!.value.isInitialized)
              AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              )
            else
              const Placeholder(
                fallbackHeight: 200,
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _recordVideo,
                  icon: const Icon(Icons.videocam),
                  label: const Text('Record'),
                ),
                ElevatedButton.icon(
                  onPressed: _pickVideo,
                  icon: const Icon(Icons.video_library),
                  label: const Text('Select'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title (optional)'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description (optional)'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            _uploading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _uploadVideo,
                    child: const Text('Upload'),
                  ),
            if (_uploadMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _uploadMessage!,
                  style: TextStyle(
                    color: _uploadMessage == 'Upload successful!' ? Colors.green : Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
