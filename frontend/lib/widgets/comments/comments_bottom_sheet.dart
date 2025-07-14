import 'package:flutter/material.dart';
import '../../services/interaction_service.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String videoId;
  final InteractionService interactionService;

  const CommentsBottomSheet({
    Key? key,
    required this.videoId,
    required this.interactionService,
  }) : super(key: key);

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  List<dynamic> _comments = [];
  bool _loading = true;
  final TextEditingController _commentController = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final comments = await widget.interactionService.fetchComments(widget.videoId);
      setState(() {
        _comments = comments;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    try {
      bool success = await widget.interactionService.addComment(widget.videoId, text);
      if (success) {
        _commentController.clear();
        await _loadComments();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add comment')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: \$e')),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Comments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text('Error: \$_error'))
                    : _comments.isEmpty
                        ? const Center(child: Text('No comments yet.'))
                        : ListView.builder(
                            itemCount: _comments.length,
                            itemBuilder: (context, index) {
                              final comment = _comments[index];
                              return ListTile(
                                title: Text(comment['user'] ?? 'Anonymous'),
                                subtitle: Text(comment['text'] ?? ''),
                              );
                            },
                          ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
