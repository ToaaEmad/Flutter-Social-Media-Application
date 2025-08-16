import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Future<void> addUser({
    required String userId,
    required String userName,
    required String email,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'userId': userId,
        'userName': userName,
        'email': email,
      });
    } catch (e) {
      print("Error adding user: $e");
    }
  }
  Future<void> addPost({
    required String authorId,
    required String authorName,
    required String content,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('posts').add({
        'authorId': authorId,
        'authorName': authorName,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding post: $e");
    }
  }
  Stream<QuerySnapshot> getPostsStream(){
    try {
      Stream<QuerySnapshot> snapshot = FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .snapshots();
      return snapshot;
    } catch (e) {
      print("Error fetching posts: $e");
      return Stream.empty();
    }
  }
  Future<void> editPost({
    required String postId,
    required String content,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error updating post: $e");
    }
  }
  Future<void> deletePost({
    required String postId,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    } catch (e) {
      print("Error deleting post: $e");
    }
  }
}