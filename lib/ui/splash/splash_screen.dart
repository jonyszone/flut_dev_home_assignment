import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_provider.dart';
import '../../res/app_icon.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context, listen: false).splashInit(context);
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(
              size: 150.0,
            ),
            SizedBox(height: 20),
            SizedBox(width: 150.0, child: LinearProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
