import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/widgets/star_display.dart';

class TitleBar extends StatelessWidget {
  TitleBar({@required this.movieObject});

  final Movie movieObject;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Flexible(
              child: Text(
                movieObject != null ? movieObject.title : '',
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
                          value: movieObject != null
                              ? movieObject.voteAverage
                              : 5),
                    ),
                    Text(
                      movieObject != null
                          ? movieObject.voteCount.toString() + ' votes'
                          : '',
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                  ],
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  movieObject != null ? movieObject.voteAverage.toString() : '',
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
