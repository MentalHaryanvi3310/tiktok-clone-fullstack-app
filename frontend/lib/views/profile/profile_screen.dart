import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../services/interaction_service.dart';
import '../../widgets/video_player_tile.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final bool isCurrentUser;
  final UserService userService;
  final InteractionService interactionService;

  const ProfileScreen({
    Key? key,
    required this.userId,
    required this.isCurrentUser,
    required this.userService,
    required this.interactionService,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profileData;
  List<dynamic> _videos = [];
  bool _loading = true;
  bool _following = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final profile = await widget.userService.fetchUserProfile(widget.userId);
      final videos = await widget.userService.fetchUserVideos(widget.userId);
      setState(() {
        _profileData = profile;
        _videos = videos;
        _following = profile['isFollowed'] ?? false;
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

  void _toggleFollow() async {
    bool success = await widget.userService.followUser(widget.userId, !_following);
    if (success) {
      setState(() {
        _following = !_following;
      });
    }
  }

  void _logout() {
    // TODO: Implement logout logic, e.g., call AuthService.signOut and navigate to login
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        body: Center(child: Text('Error: \$_error')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_profileData?['username'] ?? 'Profile'),
        actions: [
          if (widget.isCurrentUser)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_profileData?['avatarUrl'] ?? ''),
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 10),
            Text(
              _profileData?['username'] ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(_profileData?['bio'] ?? ''),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStat('Followers', _profileData?['followersCount'] ?? 0),
                const SizedBox(width: 20),
                _buildStat('Following', _profileData?['followingCount'] ?? 0),
              ],
            ),
            const SizedBox(height: 10),
            if (!widget.isCurrentUser)
              ElevatedButton(
                onPressed: _toggleFollow,
                child: Text(_following ? 'Unfollow' : 'Follow'),
              ),
            const SizedBox(height: 20),
            _videos.isEmpty
                ? const Text('No videos uploaded yet.')
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _videos.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemBuilder: (context, index) {
                      final video = _videos[index];
                      return GestureDetector(
                        onTap: () {
                          // TODO: Navigate to video detail or playback screen
                        },
                        child: Image.network(
                          video['thumbnailUrl'] ?? '',
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}
