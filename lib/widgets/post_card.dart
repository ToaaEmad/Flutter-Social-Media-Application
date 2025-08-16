import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/services/firestore_service.dart';

class PostCard extends StatefulWidget {
  final String postId; 
  final String authorName;
  final String content;
  final Timestamp? timestamp; 

  const PostCard({
    super.key,
    required this.authorName,
    required this.content,
    required this.timestamp,
    required this.postId,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late String _timeAgo;
  Timer? _timer;
  bool _isEditing = false;
  late TextEditingController _editController;

  // ...existing timeAgo and timer code...
  String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 5){
      return 'Just now';
    }else if (diff.inSeconds < 60){
      return '${diff.inSeconds} seconds ago';
    }else if (diff.inMinutes < 60){
      return '${diff.inMinutes} minutes ago';
    }else if (diff.inHours   < 24){
      return '${diff.inHours} hours ago';
    }else if (diff.inDays == 1){
      return 'Yesterday';
    }else{
      return '${diff.inDays} days ago';
    } 
  }

  void _updateTimeAgo() {
    // If timestamp is still null (local write), show "Just now"
    if (widget.timestamp == null) {
      _timeAgo = 'Just now';
    } else {
      _timeAgo = timeAgo(widget.timestamp!.toDate());
    }
    setState(() {});
  }

  @override
  void initState() {
  super.initState();
  _editController = TextEditingController(text: widget.content);
  _updateTimeAgo();
  _timer = Timer.periodic(const Duration(minutes: 1), (_) => _updateTimeAgo());
  }

  @override
  void didUpdateWidget(covariant PostCard oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (oldWidget.content != widget.content) {
  _editController.text = widget.content;
  }
  if (oldWidget.timestamp != widget.timestamp) {
  _updateTimeAgo();
  }
  }

  @override
  void dispose() {
  _timer?.cancel();
  _editController.dispose();
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return Card(
  color: Colors.white,
  elevation: 8,
  shadowColor: Colors.black54,
  margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  child: Text(
                    widget.authorName[0].toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.authorName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      _timeAgo,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ]
            ),
            FirebaseAuth.instance.currentUser?.displayName == widget.authorName
            ? PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.deepPurple),
              color: Colors.grey[200],
              onSelected: (value) async {
                if (value == 'edit') {
                  setState(() {
                    _isEditing = true;
                  });
                } else if (value == 'delete') {
                  await FirestoreService().deletePost(postId: widget.postId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Post deleted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ) : Container(),
          ],
        ),
        const SizedBox(height: 15),
        _isEditing
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _editController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    showCursor: true,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final newContent = _editController.text.trim();
                          if (newContent.isNotEmpty && newContent != widget.content) {
                            await FirestoreService().editPost(
                              postId: widget.postId,
                              content: newContent,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Post edited successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                          setState(() {
                            _isEditing = false;
                          });
                        },
                        child: const Text('Save'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                         setState(() {
                            _isEditing = false;
                            _editController.text = widget.content;
                          });
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              )
            : Text(
                widget.content,
                style: const TextStyle(fontSize: 16),
              ),

            const SizedBox(height: 15),
            // Row(
            //   children: [
            //     Icon(Icons.thumb_up, size: 18, color: Colors.blue),
            //     const SizedBox(width: 4),
            //     Text('${post["likes"]}'),
            //     const SizedBox(width: 16),
            //     Icon(Icons.comment, size: 18, color: Colors.grey),
            //     const SizedBox(width: 4),
            //     Text('${post["comments"].length}'),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
