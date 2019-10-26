import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_data.dart';
import 'package:movie_app/widgets/star_display.dart';
import 'package:provider/provider.dart';

class TitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Consumer<MovieData>(builder: (context, movieData, child) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Flexible(
                child: Text(
                  movieData.currentMovie != null
                      ? movieData.currentMovie.title
                      : '',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      IconTheme(
                        data: IconThemeData(
                          color: Colors.amber,
                          size: 16,
                        ),
                        child: StarDisplay(
                            value: movieData.currentMovie != null
                                ? movieData.currentMovie.voteAverage
                                : 5),
                      ),
                      Text(
                        movieData.currentMovie != null
                            ? movieData.currentMovie.voteCount.toString() +
                                ' votes'
                            : '',
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    movieData.currentMovie != null
                        ? movieData.currentMovie.voteAverage.toString()
                        : '',
                    style: Theme.of(context).textTheme.display1,
                  ),
                ],
              ),
            ],
          );
        }),
      ],
    );
  }
}
