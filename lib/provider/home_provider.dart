import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/post.dart';

class HomeProvider with ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;
  final String _baseUrl = 'https://jsonplaceholder.typicode.com';

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$_baseUrl/posts'));
      if (response.statusCode == 200) {
        _posts = (json.decode(response.body) as List)
            .map((data) => Post.fromJson(data))
            .toList();
        _errorMessage = null;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      _errorMessage = 'Failed to load posts: ${e.toString()}';
      if (kDebugMode) print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePost(int index, Post updatedPost) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/posts/${updatedPost.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedPost.toJson()),
      );

      if (response.statusCode == 200) {
        _posts[index] = Post.fromJson(json.decode(response.body));
        _errorMessage = null;
      } else {
        throw Exception('Failed to update post');
      }
    } catch (e) {
      _errorMessage = 'Failed to update post: ${e.toString()}';
      if (kDebugMode) print(e);
      // Revert UI change if API fails
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePost(int index) async {
    final postId = _posts[index].id;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/posts/$postId'),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _posts.removeAt(index);
        _errorMessage = null;
      } else {
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      _errorMessage = 'Failed to delete post: ${e.toString()}';
      if (kDebugMode) print(e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}