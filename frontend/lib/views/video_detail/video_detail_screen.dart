import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../services/interaction_service.dart';
import '../../widgets/comments/comments_bottom_sheet.dart';

class VideoDetailScreen extends StatefulWidget {
  final String videoId;
  final String videoUrl;
  final InteractionService interactionService;

  const VideoDetailScreen({
    Key? key,
    required this.videoId,
    required this.videoUrl,
    required this.interactionService,
  }) : super(key: key);

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  late VideoPlayerController _controller;
  bool _liked = false;
  int _likeCount = 0;
  int _commentCount = 0;
  int _shareCount = 0; // Placeholder, can be updated with real data

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
    // TODO: Fetch video stats (likes, comments, shares) from backend
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleLike() async {
    bool success = await widget.interactionService.likeVideo(widget.videoId, !_liked);
    if (success) {
      setState(() {
        _liked = !_liked;
        _likeCount += _liked ? 1 : -1;
      });
    }
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      builder: (context) => CommentsBottomSheet(
        videoId: widget.videoId,
        interactionService: widget.interactionService,
      ),
    );
  }

  void _shareVideo() {
    // Mock share behavior: copy link to clipboard or show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share link copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Detail'),
      ),
      body: _controller.value.isInitialized
          ? Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 50,
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          _liked ? Icons.favorite : Icons.favorite_border,
                          color: _liked ? Colors.red : Colors.white,
                          size: 30,
                        ),
                        onPressed: _toggleLike,
                      ),
                      Text('$_likeCount', style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 10),
                      IconButton(
                        icon: const Icon(Icons.comment, color: Colors.white, size: 30),
                        onPressed: _showComments,
                      ),
                      Text('$_commentCount', style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 10),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white, size: 30),
                        onPressed: _shareVideo,
                      ),
                      Text('$_shareCount', style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
