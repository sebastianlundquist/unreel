import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:unreel/models/languages.dart';
import 'package:unreel/models/movie.dart';
import 'package:unreel/widgets/description_row.dart';

List<String> genres;
List<String> productionCountries;
List<String> productionCompanies;

class MovieDescription extends StatelessWidget {
  MovieDescription({@required this.movieObject});
  final Movie movieObject;
  @override
  Widget build(BuildContext context) {
    genres = [];
    productionCountries = [];
    productionCompanies = [];
    if (movieObject != null) {
      for (int i = 0; i < movieObject.genres.length; i++) {
        genres.add(movieObject.genres[i]['name']);
      }
      for (int i = 0; i < movieObject.productionCountries.length; i++) {
        productionCountries.add(movieObject.productionCountries[i]['name']);
      }
      for (int i = 0; i < movieObject.productionCompanies.length; i++) {
        productionCompanies.add(movieObject.productionCompanies[i]['name']);
      }
    }
    return Expanded(
      child: FadingEdgeScrollView.fromScrollView(
        gradientFractionOnEnd: 0.15,
        child: ListView(
          controller: ScrollController(),
          padding: EdgeInsets.all(0.0),
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                movieObject != null ? movieObject.overview : '',
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: <Widget>[
                  if (movieObject != null &&
                      movieObject.title != movieObject.originalTitle)
                    DescriptionRow(
                      title: "Original Title:",
                      description: movieObject.originalTitle,
                    ),
                  DescriptionRow(
                    title: "Genres:",
                    description: genres.join(', '),
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
                  DescriptionRow(
                    title: "Production:",
                    description: productionCompanies.join(', '),
                  ),
                  DescriptionRow(
                    title: "Locations:",
                    description: productionCountries.join(', '),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
