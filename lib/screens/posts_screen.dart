import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/screens/auth_screen.dart';
import 'package:social_media_app/services/firestore_service.dart';
import 'package:social_media_app/widgets/post_card.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController postController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "Hello, ${FirebaseAuth.instance.currentUser?.displayName ?? 'Guest'}!",
              ),
              accountEmail: Text(
                FirebaseAuth.instance.currentUser?.email ?? 'No Email',
              ),
              currentAccountPicture: CircleAvatar(
                child: Text(
                  FirebaseAuth.instance.currentUser?.displayName?[0].toUpperCase() ??'Unknown email',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              decoration: const BoxDecoration(color: Colors.deepPurple),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.deepPurple),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Text(
                      FirebaseAuth.instance.currentUser?.displayName?[0].toUpperCase() ??'Guest',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: postController,
                      decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.deepPurple),
                    onPressed: () async {
                      if (postController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Post content cannot be empty'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      await FirestoreService().addPost(
                        authorId: FirebaseAuth.instance.currentUser!.uid,
                        authorName:
                            FirebaseAuth.instance.currentUser!.displayName!,
                        content: postController.text,
                      );
                      postController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Post added successfuly!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirestoreService().getPostsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else {
                    final posts = snapshot.data?.docs ?? [];
                    if (posts.isEmpty) {
                      return Center(child: Text("No posts available."));
                    } else {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return PostCard(
                            authorName: post["authorName"],
                            content: post["content"],
                            timestamp: post["timestamp"],
                            postId: post.id,
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
