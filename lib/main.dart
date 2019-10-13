import 'package:flutter/material.dart';
import 'package:movie_app/screens/navigation_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF131C25),
        accentColor: Colors.amber,
        scaffoldBackgroundColor: Color(0xFF131C25),
        textTheme: Typography.whiteMountainView.copyWith(
            display1:
                Theme.of(context).textTheme.display1.apply(color: Colors.white),
            subtitle: Theme.of(context).textTheme.subtitle.apply(
                  color: Color(0xAAFFFFFF),
                )),
      ),
      home: NavigationScreen(),
    );
  }
}
