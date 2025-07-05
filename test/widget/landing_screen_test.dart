import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:flut_dev_home_assignment/provider/home_provider.dart';
import 'package:flut_dev_home_assignment/ui/home/landing_screen.dart';
import 'package:flut_dev_home_assignment/model/post.dart';
import '../providers/mock_home_provider_test.mocks.dart';

void main() {
  late MockHomeProvider mockProvider;

  final testPosts = [
    Post(id: 1, userId: 1, title: 'Test Title 1', body: 'Test Body 1'),
    Post(id: 2, userId: 1, title: 'Test Title 2', body: 'Test Body 2'),
  ];

  setUp(() {
    mockProvider = MockHomeProvider();

    when(mockProvider.fetchPosts()).thenAnswer((_) async => {});
    when(mockProvider.filterPosts(any)).thenReturn(null);
    when(mockProvider.toggleSearch()).thenReturn(null);

    // Stub counts so AppBar text fits
    when(mockProvider.totalPostsCount).thenReturn(2);
    when(mockProvider.displayedPostsCount).thenReturn(2);
  });


  testWidgets('shows loading indicator when loading and no posts', (tester) async {
    when(mockProvider.isLoading).thenReturn(true);
    when(mockProvider.posts).thenReturn([]);
    when(mockProvider.filteredPosts).thenReturn([]);
    when(mockProvider.errorMessage).thenReturn(null);
    when(mockProvider.showSearch).thenReturn(false);

    await tester.pumpWidget(
      ChangeNotifierProvider<HomeProvider>.value(
        value: mockProvider,
        child: MaterialApp(home: LandingScreen()),
      ),
    );

    await tester.pump(); // Allow post-frame fetchPosts

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays list of posts when data is available', (tester) async {
    when(mockProvider.isLoading).thenReturn(false);
    when(mockProvider.posts).thenReturn(testPosts);
    when(mockProvider.filteredPosts).thenReturn(testPosts);
    when(mockProvider.errorMessage).thenReturn(null);
    when(mockProvider.showSearch).thenReturn(false);
    when(mockProvider.totalPostsCount).thenReturn(testPosts.length);
    when(mockProvider.displayedPostsCount).thenReturn(testPosts.length);

    await tester.pumpWidget(
      ChangeNotifierProvider<HomeProvider>.value(
        value: mockProvider,
        child: MaterialApp(home: LandingScreen()),
      ),
    );

    await tester.pump(); // Build with posts

    expect(find.text('Test Title 1'), findsOneWidget);
    expect(find.text('Test Title 2'), findsOneWidget);
  });

  testWidgets('shows error message if provider has error', (tester) async {
    when(mockProvider.isLoading).thenReturn(false);
    when(mockProvider.posts).thenReturn([]);
    when(mockProvider.filteredPosts).thenReturn([]);
    when(mockProvider.errorMessage).thenReturn('Something went wrong');
    when(mockProvider.showSearch).thenReturn(false);

    await tester.pumpWidget(
      ChangeNotifierProvider<HomeProvider>.value(
        value: mockProvider,
        child: MaterialApp(home: LandingScreen()),
      ),
    );

    expect(find.text('Something went wrong'), findsOneWidget);
  });

  testWidgets('shows empty state when no posts found', (tester) async {
    when(mockProvider.isLoading).thenReturn(false);
    when(mockProvider.posts).thenReturn([]);
    when(mockProvider.filteredPosts).thenReturn([]);
    when(mockProvider.searchQuery).thenReturn('');
    when(mockProvider.errorMessage).thenReturn(null);
    when(mockProvider.showSearch).thenReturn(false);

    await tester.pumpWidget(
      ChangeNotifierProvider<HomeProvider>.value(
        value: mockProvider,
        child: MaterialApp(home: LandingScreen()),
      ),
    );

    expect(find.text('No posts available'), findsOneWidget);
  });

  testWidgets('shows search bar when showSearch is true', (tester) async {
    when(mockProvider.isLoading).thenReturn(false);
    when(mockProvider.posts).thenReturn(testPosts);
    when(mockProvider.filteredPosts).thenReturn(testPosts);
    when(mockProvider.searchQuery).thenReturn('');
    when(mockProvider.errorMessage).thenReturn(null);
    when(mockProvider.showSearch).thenReturn(true);
    when(mockProvider.totalPostsCount).thenReturn(testPosts.length);
    when(mockProvider.displayedPostsCount).thenReturn(testPosts.length);

    await tester.pumpWidget(
      ChangeNotifierProvider<HomeProvider>.value(
        value: mockProvider,
        child:  MaterialApp(home: LandingScreen()),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('opens create post bottom sheet', (tester) async {
    when(mockProvider.isLoading).thenReturn(false);
    when(mockProvider.posts).thenReturn(testPosts);
    when(mockProvider.filteredPosts).thenReturn(testPosts);
    when(mockProvider.showSearch).thenReturn(false);
    when(mockProvider.searchQuery).thenReturn('');
    when(mockProvider.errorMessage).thenReturn(null);

    await tester.pumpWidget(
      ChangeNotifierProvider<HomeProvider>.value(
        value: mockProvider,
        child: MaterialApp(home: LandingScreen()),
      ),
    );

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Create Post'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
  });
}
