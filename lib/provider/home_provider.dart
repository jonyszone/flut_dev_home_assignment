import 'package:flutter/foundation.dart';
import '../config/api_service.dart';
import '../model/post.dart';

class HomeProvider with ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _posts = await ApiService().fetchPosts();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load posts: ${e.toString()}';
      if (kDebugMode) print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  //call an API to delete/update from server
  void updatePost(int index, Post updatedPost) {
    _posts[index] = updatedPost;
    notifyListeners();
  }

  void deletePost(int index) {
    _posts.removeAt(index);
    notifyListeners();

  }
}