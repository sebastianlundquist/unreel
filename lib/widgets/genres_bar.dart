import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';

bool isFavorite = false;
String genresString = "";

class GenresBar extends StatefulWidget {
  GenresBar({@required this.movieObject});
  final Movie movieObject;
  @override
  _GenresBarState createState() => _GenresBarState();
}

class _GenresBarState extends State<GenresBar> {
  List<Widget> genreWidgets(List<dynamic> genres) {
    var list = List<Widget>();
    genresString = "";
    int count = genres.length > 3 ? 3 : genres.length;
    for (int i = 0; i < count; i++) {
      list.add(
        Padding(
          padding: i != 0
              ? const EdgeInsets.symmetric(horizontal: 4.0)
              : EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 0.0),
          child: Chip(
            backgroundColor: Colors.blueGrey[900],
            elevation: 8.0,
            labelPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
            label: Text(
              genres[i]['name'],
              style: Theme.of(context).textTheme.button.copyWith(
                    fontSize: 12,
                  ),
            ),
          ),
        ),
      );
      genresString += genres[i]['name'];
      if (i < genres.length - 1) {
        genresString += ', ';
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: genreWidgets(
                widget.movieObject != null && widget.movieObject.genres != null
                    ? widget.movieObject.genres
                    : []),
          ),
          IconButton(
            icon: isFavorite
                ? Icon(
                    Icons.favorite,
                  )
                : Icon(
                    Icons.favorite_border,
                  ),
            onPressed: () {
              setState(
                () {
                  isFavorite = !isFavorite;
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
