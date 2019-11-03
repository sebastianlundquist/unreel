import 'package:flutter/material.dart';
import 'package:unreel/models/movie.dart';
import 'package:unreel/widgets/genres_bar.dart';
import 'package:unreel/widgets/movie_description.dart';
import 'package:unreel/widgets/title_display.dart';

class MovieScreen extends StatelessWidget {
  MovieScreen({@required this.movie});
  final Movie movie;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF131C25),
      body: Column(
        children: <Widget>[
          TitleDisplay(
            movie: movie,
            isSaved: true,
          ),
          GenresBar(movie: movie),
          MovieDescription(movieObject: movie),
        ],
      ),
    );
  }
}
