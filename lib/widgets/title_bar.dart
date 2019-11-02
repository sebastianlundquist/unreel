import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/widgets/star_display.dart';

class TitleBar extends StatelessWidget {
  final Movie movie;
  TitleBar({@required this.movie});
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
                movie != null ? movie.title : '',
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
                          value: movie != null ? movie.voteAverage : 5),
                    ),
                    Text(
                      movie != null
                          ? movie.voteCount.toString() + ' votes'
                          : '',
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                  ],
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  movie != null ? movie.voteAverage.toString() : '',
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
