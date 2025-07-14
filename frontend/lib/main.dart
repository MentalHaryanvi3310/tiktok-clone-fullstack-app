import 'package:flutter/material.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/signup_screen.dart';

void main() {
  runApp(const TikTokCloneApp());
}

class TikTokCloneApp extends StatelessWidget {
  const TikTokCloneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TikTok Clone',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/upload': (context) => const UploadScreen(),
        '/profile': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final userId = args?['userId'] as String? ?? '';
          final isCurrentUser = args?['isCurrentUser'] as bool? ?? false;
          return ProfileScreen(
            userId: userId,
            isCurrentUser: isCurrentUser,
            userService: UserService(baseUrl: 'http://localhost:3000'),
            interactionService: InteractionService(baseUrl: 'http://localhost:3000'),
          );
        },
        '/video-detail': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final videoId = args?['videoId'] as String? ?? '';
          final videoUrl = args?['videoUrl'] as String? ?? '';
          return VideoDetailScreen(
            videoId: videoId,
            videoUrl: videoUrl,
            interactionService: InteractionService(baseUrl: 'http://localhost:3000'),
          );
        },
      },
    );
  }
}
