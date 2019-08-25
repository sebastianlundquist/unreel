import 'package:flutter/material.dart';
import 'package:movie_app/screens/recommendation_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'Roboto',
          backgroundColor: Color(0xFF131C25),
          scaffoldBackgroundColor: Color(0xFF000000),
          accentColor: Colors.white,
          textTheme: Typography.whiteMountainView),
      home: RecommendationScreen(),
    );
  }
}
