import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../services/interaction_service.dart';
import 'comments/comments_bottom_sheet.dart';

class VideoPlayerTile extends StatefulWidget {
  final String videoUrl;
  final String videoId;
  final String uploaderUserId;
  final InteractionService interactionService;

  const VideoPlayerTile({
    Key? key,
    required this.videoUrl,
    required this.videoId,
    required this.uploaderUserId,
    required this.interactionService,
  }) : super(key: key);

  @override
  State<VideoPlayerTile> createState() => _VideoPlayerTileState();
}

class _VideoPlayerTileState extends State<VideoPlayerTile> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _liked = false;
  int _likeCount = 0;
  bool _following = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _isPlaying = true;
      });
    _controller.setLooping(true);
    // TODO: Load initial like count, liked status, and following status from backend
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      _controller.play();
      setState(() {
        _isPlaying = true;
      });
    }
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

  void _toggleFollow() async {
    bool success = await widget.interactionService.followUser(widget.uploaderUserId, !_following);
    if (success) {
      setState(() {
        _following = !_following;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            children: [
              GestureDetector(
                onTap: _togglePlayPause,
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
                    const SizedBox(height: 10),
                    IconButton(
                      icon: Icon(
                        _following ? Icons.person_remove : Icons.person_add,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: _toggleFollow,
                    ),
                  ],
                ),
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}
