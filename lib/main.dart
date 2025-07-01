import 'package:flut_dev_home_assignment/provider/theme_provider.dart';
import 'package:flut_dev_home_assignment/route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()..initialize()),
      /*ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ChangeNotifierProvider(create: (_) => AppProvider()),*/
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
