import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Posts Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF305AB8),
          primary: const Color(0xFF305AB8),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF305AB8),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: const UsersScreen(),
    );
  }
}

/* -------------------- ENHANCED DATA GENERATOR -------------------- */
class EnglishContent {
  // Expanded list of unique users
  static String getUniqueName(int id) {
    const names = [
      "Leanne Graham", "Ervin Howell", "Clementine Bauch", "Patricia Lebsack", 
      "Chelsey Dietrich", "Mrs. Dennis Schulist", "Kurtis Weissnat", 
      "Nicholas Runolfsdottir", "Glenna Reichert", "Clementina DuBuque",
      "Alice Freeman", "James Miller", "Sarah Connor"
    ];
    return names[(id - 1) % names.length];
  }

  // Meaningful English Posts
  static Map<String, String> getUniquePost(int id) {
    const posts = [
      {
        "title": "Tips for Better Productivity",
        "body": "Starting your day with a clear plan and a prioritized to-do list can significantly reduce stress and help you stay focused on your most important tasks."
      },
      {
        "title": "The Benefits of Regular Exercise",
        "body": "Physical activity is not just about staying fit; it releases endorphins that improve your mood and boost your long-term mental health."
      },
      {
        "title": "Healthy Eating Habits",
        "body": "Incorporating more whole foods like fruits, vegetables, and nuts into your diet can lead to higher energy levels and a stronger immune system."
      },
      {
        "title": "The Future of Mobile Tech",
        "body": "Cross-platform frameworks like Flutter are revolutionizing how we build apps, allowing developers to reach more users with a single codebase."
      },
      {
        "title": "Weekend Travel Destinations",
        "body": "Exploring nearby nature trails or small historic towns is a great way to recharge without needing a long vacation from work."
      }
    ];
    return posts[(id - 1) % posts.length];
  }

  // Meaningful, Non-Lorem Ipsum Comments
  static Map<String, String> getUniqueComment(int index) {
    const comments = [
      {"name": "John Doe", "email": "john.doe@example.com", "body": "This is excellent advice! I tried the morning routine today and felt much more focused."},
      {"name": "Jane Smith", "email": "jane.smith@example.com", "body": "Thanks for sharing this. I’ve been struggling with my energy levels lately, and this helps."},
      {"name": "Robert Brown", "email": "robert.brown@example.com", "body": "Really interesting perspective. Do you have any recommendations for specific apps to help?"},
      {"name": "Emily White", "email": "emily.w@test.com", "body": "I completely agree with the point about mental health. Exercise has been a lifesaver for me."},
      {"name": "Michael Scott", "email": "m.scott@dunder.com", "body": "Great read! Short, concise, and very practical. Looking forward to more posts like this."},
      {"name": "Pam Beesly", "email": "pam.b@design.com", "body": "The way you explained the benefits of whole foods was very clear. I'm going to start meal prepping!"}
    ];
    return comments[index % comments.length];
  }
}

/* -------------------- USERS SCREEN -------------------- */
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  Future<List<dynamic>> fetchUsers() async {
    final res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    if (res.statusCode == 200) return json.decode(res.body);
    throw Exception('Failed to load users');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: FutureBuilder<List<dynamic>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return const Center(child: Text('Error loading users'));
          
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length, // Now dynamic to show more users
            itemBuilder: (context, i) {
              final id = users[i]['id'];
              final name = EnglishContent.getUniqueName(id);
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(users[i]['email'].toString().toLowerCase()),
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => PostsScreen(userId: id, userName: name),
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

/* -------------------- POSTS SCREEN -------------------- */
class PostsScreen extends StatelessWidget {
  final int userId;
  final String userName;
  const PostsScreen({super.key, required this.userId, required this.userName});

  Future<List<dynamic>> fetchPosts() async {
    final res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts?userId=$userId'));
    if (res.statusCode == 200) return json.decode(res.body);
    throw Exception('Failed to load posts');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF305AB8),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CreatePostScreen(userId: userId))),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length > 5 ? 5 : posts.length, // Showing up to 5 posts
            itemBuilder: (context, i) {
              final content = EnglishContent.getUniquePost(i + 1);
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(content['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(content['body']!, maxLines: 2, overflow: TextOverflow.ellipsis),
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => PostDetailScreen(postId: posts[i]['id'], postData: content),
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

/* -------------------- POST DETAIL SCREEN -------------------- */
class PostDetailScreen extends StatelessWidget {
  final int postId;
  final Map<String, String> postData;
  const PostDetailScreen({super.key, required this.postId, required this.postData});

  Future<List<dynamic>> fetchComments() async {
    final res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/comments?postId=$postId'));
    if (res.statusCode == 200) return json.decode(res.body);
    throw Exception('Failed to load comments');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(postData['title']!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(postData['body']!, style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4)),
            const Divider(height: 40),
            const Text('Comments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF305AB8))),
            const SizedBox(height: 10),
            FutureBuilder<List<dynamic>>(
              future: fetchComments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                
                // Show up to 4 meaningful comments
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4, 
                  itemBuilder: (context, i) {
                    final comment = EnglishContent.getUniqueComment(i + (postId * 2));
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, size: 22, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(color: Colors.black, fontSize: 13),
                                    children: [
                                      TextSpan(text: comment['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: " • ${comment['email']}", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(comment['body']!, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/* -------------------- CREATE POST SCREEN -------------------- */
class CreatePostScreen extends StatefulWidget {
  final int userId;
  const CreatePostScreen({super.key, required this.userId});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController, 
              decoration: const InputDecoration(hintText: 'Title', border: OutlineInputBorder())
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _bodyController, 
              maxLines: 5, 
              decoration: const InputDecoration(hintText: 'Enter your post content...', border: OutlineInputBorder())
            ),
            const SizedBox(height: 10),
            if (_showError) 
              const Text('Title and body are required!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF305AB8), 
                  foregroundColor: Colors.white, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                ),
                onPressed: () {
                  if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
                    setState(() => _showError = true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Post Submitted Successfully")));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
