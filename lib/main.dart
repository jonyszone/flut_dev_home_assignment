import 'package:flut_dev_home_assignment/provider/home_provider.dart';
import 'package:flut_dev_home_assignment/provider/theme_provider.dart';
import 'package:flut_dev_home_assignment/route.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'model/post.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive
  openAppDatabase();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()..initialize()),
      ChangeNotifierProvider(create: (_) => HomeProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Dev Home Assignment',
          theme: provider.lightTheme,
          darkTheme: provider.darkTheme,
          themeMode: provider.themeMode,
          initialRoute: RouteName.splashScreen,
          onGenerateRoute: onGenerateRoute);
    });
  }
}

Future<void> openAppDatabase() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PostAdapter());
  if (!Hive.isBoxOpen('postsBox')) {
    await Hive.openBox<Post>('postsBox');
  }
}
