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
          accentColor: Color(0xFF38CCAC),
          scaffoldBackgroundColor: Color(0xFF131C25),
          textTheme: Typography.whiteMountainView),
      home: NavigationScreen(),
    );
  }
}
