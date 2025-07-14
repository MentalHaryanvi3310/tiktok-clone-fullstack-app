import 'package:flutter/material.dart';
import '../../services/feed_service.dart';
import '../../widgets/video_player_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FeedService _feedService = FeedService(baseUrl: 'http://localhost:3000'); // Update with backend URL
  List<dynamic> _forYouVideos = [];
  List<dynamic> _followingVideos = [];
  bool _loadingForYou = true;
  bool _loadingFollowing = true;
  String? _errorForYou;
  String? _errorFollowing;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchFeeds();
  }

  Future<void> _fetchFeeds() async {
    try {
      final forYou = await _feedService.fetchForYouFeed();
      setState(() {
        _forYouVideos = forYou;
        _loadingForYou = false;
      });
    } catch (e) {
      setState(() {
        _errorForYou = e.toString();
        _loadingForYou = false;
      });
    }

    try {
      final following = await _feedService.fetchFollowingFeed();
      setState(() {
        _followingVideos = following;
        _loadingFollowing = false;
      });
    } catch (e) {
      setState(() {
        _errorFollowing = e.toString();
        _loadingFollowing = false;
      });
    }
  }

  Widget _buildVideoList(List<dynamic> videos) {
    if (videos.isEmpty) {
      return const Center(child: Text('No videos available.'));
    }
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return VideoPlayerTile(
          videoUrl: video['videoUrl'] ?? '',
          onLike: () {
            // TODO: Implement like action
          },
          onComment: () {
            // TODO: Implement comment action
          },
          onShare: () {
            // TODO: Implement share action
          },
        );
      },
    );
  }

  Widget _buildTabContent(bool loading, String? error, List<dynamic> videos) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(child: Text('Error: \$error'));
    }
    return _buildVideoList(videos);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TikTok Clone'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'For You'),
            Tab(text: 'Following'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent(_loadingForYou, _errorForYou, _forYouVideos),
          _buildTabContent(_loadingFollowing, _errorFollowing, _followingVideos),
        ],
      ),
    );
  }
}
