import 'package:flutter/material.dart';
import 'package:movie_app/models/languages.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/widgets/genres_bar.dart';
import 'package:intl/intl.dart';
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
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
            child: Text(
              movieObject != null ? movieObject.tagline : '',
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
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
                  description: movieObject != null && movieObject.genres != null
                      ? genresString
                      : '',
                ),
                DescriptionRow(
                  title: "Premiere:",
                  description: movieObject != null
                      ? DateFormat.yMMMMd()
                          .format(DateTime.parse(movieObject.releaseDate))
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
