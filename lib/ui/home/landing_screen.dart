import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flut_dev_home_assignment/provider/home_provider.dart';

import '../../model/post.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch posts when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchPosts();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => Provider.of<HomeProvider>(context, listen: false).fetchPosts(),
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.posts.isEmpty) {
            return const Center(child: Text('No posts available'));
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: provider.posts.length,
            itemBuilder: (context, index) {
              final post = provider.posts[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    post.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(post.body),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditBottomSheet(context, provider, post, index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => provider.deletePost(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditBottomSheet(BuildContext context, HomeProvider provider, Post post, int index) {
    final titleController = TextEditingController(text: post.title);
    final bodyController = TextEditingController(text: post.body);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Edit Post',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bodyController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Body',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final updatedPost = post.copyWith(
                      title: titleController.text,
                      body: bodyController.text,
                    );
                    provider.updatePost(index, updatedPost);
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}