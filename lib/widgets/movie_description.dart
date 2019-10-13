import 'package:flutter/material.dart';
import 'package:movie_app/models/genres.dart';
import 'package:movie_app/models/languages.dart';
import 'package:movie_app/models/movie.dart';
import 'description_row.dart';

class MovieDescription extends StatelessWidget {
  MovieDescription({@required this.movieObject});
  final Movie movieObject;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              movieObject != null ? movieObject.overview : '',
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                DescriptionRow(
                  title: "Original Title:",
                  description:
                      movieObject != null ? movieObject.originalTitle : '',
                ),
                DescriptionRow(
                  title: "Genres:",
                  description: movieObject != null &&
                          movieObject.genreIds != null
                      ? getGenreNamesFromIdList(movieObject.genreIds).join(', ')
                      : '',
                ),
                DescriptionRow(
                  title: "Release Date:",
                  description: movieObject != null
                      ? movieObject.releaseDate.toString()
                      : '',
                ),
                DescriptionRow(
                  title: "Original Language:",
                  description: movieObject != null
                      ? findLanguage(movieObject.originalLanguage)
                      : '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
