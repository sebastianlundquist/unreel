import 'package:flutter/material.dart';
import 'package:movie_app/screens/recommendation_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey[800],
          accentColor: Color(0xFF38CCAC),
          scaffoldBackgroundColor: Colors.blueGrey[800],
          textTheme: Typography.whiteMountainView),
      home: RecommendationScreen(),
    );
  }
}
