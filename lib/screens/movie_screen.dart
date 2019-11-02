import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/widgets/genres_bar.dart';
import 'package:movie_app/widgets/movie_description.dart';
import 'package:movie_app/widgets/title_display.dart';

class MovieScreen extends StatelessWidget {
  MovieScreen({@required this.movie});
  final Movie movie;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF131C25),
      body: Column(
        children: <Widget>[
          TitleDisplay(movie: movie),
          GenresBar(movie: movie),
          MovieDescription(movieObject: movie),
        ],
      ),
    );
  }
}
