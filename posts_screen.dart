import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'post_detail_screen.dart';

class PostsScreen extends StatelessWidget {
  final UserModel user;
  const PostsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: FutureBuilder<List<PostModel>>(
        future: ApiService().fetchPosts(user.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return const Center(child: Text('Error loading posts'));
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, i) {
              final post = posts[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => PostDetailScreen(post: post),
                  )),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
