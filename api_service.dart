import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<UserModel>> fetchUsers() async {
    final res = await http.get(Uri.parse('$baseUrl/users'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load users');
  }

  Future<List<PostModel>> fetchPosts(int userId) async {
    final res = await http.get(Uri.parse('$baseUrl/posts?userId=$userId'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => PostModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load posts');
  }

  Future<List<CommentModel>> fetchComments(int postId) async {
    final res = await http.get(Uri.parse('$baseUrl/comments?postId=$postId'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => CommentModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load comments');
  }
}
