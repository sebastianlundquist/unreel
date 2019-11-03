import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:unreel/models/movie_data.dart';
import 'package:unreel/screens/navigation_screen.dart';
import 'package:unreel/models/settings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (context) => Settings(),
        ),
        ChangeNotifierProvider(
          builder: (context) => MovieData(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(0xFF131C25),
          accentColor: Colors.amber,
          scaffoldBackgroundColor: Color(0xFF131C25),
          textTheme: Typography.whiteMountainView.copyWith(
              display1: Theme.of(context)
                  .textTheme
                  .display1
                  .apply(color: Colors.white),
              subtitle: Theme.of(context).textTheme.subtitle.apply(
                    color: Color(0xAAFFFFFF),
                  )),
        ),
        home: NavigationScreen(),
      ),
    );
  }
}
