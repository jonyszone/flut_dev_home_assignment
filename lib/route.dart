import 'package:flut_dev_home_assignment/ui/home/landing_screen.dart';
import 'package:flut_dev_home_assignment/ui/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class RouteName {
  static String splashScreen = "/splash_screen";
  static String landingScreen= '/landing_screen';
}


Map<String, WidgetBuilder> routes({Object? arg}) =>
    {
      RouteName.splashScreen: (context) => const SplashScreen(),
      RouteName.landingScreen: (context) => const LandingScreen(),
    };

Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
  final Function? builder =
  routes(arg: routeSettings.arguments)[routeSettings.name];
  if (builder != null) {
    return PageRouteBuilder(
      settings: routeSettings,
      pageBuilder: (context, animation, secondaryAnimation) =>
          builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Start off-screen
        const end = Offset.zero; // End at the original position
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  } else {
    return PageRouteBuilder(
      settings: routeSettings,
      pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text('Page not found for ${routeSettings.name}'),
        ),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Start off-screen
        const end = Offset.zero; // End at the original position
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}