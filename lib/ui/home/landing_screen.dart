import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flut_dev_home_assignment/provider/home_provider.dart';
import '../../model/post.dart';
import '../../route.dart';

class LandingScreen extends StatelessWidget {
   LandingScreen({super.key});
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Fetch posts when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchPosts();
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateBottomSheet(context),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return provider.showSearch
                ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search posts...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) => provider.filterPosts(value),
            )
                : const Text('Posts');
          },
        ),
        automaticallyImplyLeading: false,
        actions: [
          Consumer<HomeProvider>(
            builder: (context, provider, child) {
              if (!provider.showSearch) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  child: Text(
                    '${provider.displayedPostsCount}/${provider.totalPostsCount}',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          Consumer<HomeProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Icon(provider.showSearch ? Icons.close : Icons.search),
                onPressed: () {
                  if (provider.showSearch) {
                    _searchController.clear();
                    provider.filterPosts('');
                  }
                  provider.toggleSearch();
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () => provider.fetchPosts(),
            child: _buildPostList(context, provider),
          );
        },
      ),
    );
  }

  Widget _buildPostList(BuildContext context, HomeProvider provider) {
    if (provider.isLoading && provider.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(child: Text(provider.errorMessage!));
    }

    final displayPosts = provider.filteredPosts;

    if (displayPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 48),
            const SizedBox(height: 16),
            Text(
              provider.searchQuery.isEmpty
                  ? 'No posts available'
                  : 'No matching posts found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (provider.searchQuery.isNotEmpty)
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  provider.filterPosts('');
                },
                child: const Text('Clear search'),
              ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: displayPosts.length,
      itemBuilder: (context, index) {
        final post = displayPosts[index];
        return GestureDetector(
          onTap: () => _navigateToPostDetails(context, post),
          child: Card(
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToPostDetails(BuildContext context, Post post) {
    Navigator.pushNamed(
      context,
      RouteName.postDetailsScreen,
      arguments: post,
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
                  onPressed: () async {
                    try {
                      final updatedPost = post.copyWith(
                        title: titleController.text,
                        body: bodyController.text,
                      );
                      await provider.updatePost(index, updatedPost);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Post updated successfully')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update: $e')),
                      );
                    }
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

   void _showCreateBottomSheet(BuildContext context) {
     final titleController = TextEditingController();
     final bodyController = TextEditingController();
     final provider = Provider.of<HomeProvider>(context, listen: false);

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
               'Create Post',
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
                   style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                   child: const Text('Cancel'),
                 ),
                 ElevatedButton(
                   onPressed: () async {
                     if (titleController.text.isEmpty || bodyController.text.isEmpty) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Please fill all fields')),
                       );
                       return;
                     }

                     try {
                       final newPost = Post(
                         userId: 1, // placeholder or dynamic
                         id: 0, // jsonplaceholder will assign
                         title: titleController.text,
                         body: bodyController.text,
                       );
                       await provider.createPost(newPost);
                       Navigator.pop(context);
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Post created successfully')),
                       );
                     } catch (e) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text('Failed to create post: $e')),
                       );
                     }
                   },
                   child: const Text('Create'),
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