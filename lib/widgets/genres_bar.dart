import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:movie_app/models/database.dart';
import 'package:movie_app/models/movie.dart';
import 'package:path_provider/path_provider.dart';

bool isFavorite = false;

class GenresBar extends StatefulWidget {
  GenresBar({@required this.movie});
  final Movie movie;
  @override
  _GenresBarState createState() => _GenresBarState();
}

class _GenresBarState extends State<GenresBar> {
  Future<String> saveImageToFile(String imageUrl, bool isBackdrop) async {
    var fullUrl = 'https://image.tmdb.org/t/p';
    if (isBackdrop)
      fullUrl += '/w780' + imageUrl;
    else
      fullUrl += '/w300' + imageUrl;
    var response = await get(fullUrl);
    String documentsDirectory = (await getApplicationDocumentsDirectory()).path;
    File file = new File(documentsDirectory + imageUrl);
    file.writeAsBytesSync(response.bodyBytes);
    return file.path;
  }

  deleteImage(String imageUrl) async {
    final dir =
        Directory((await getApplicationDocumentsDirectory()).path + imageUrl);
    dir.deleteSync(recursive: true);
  }

  List<Widget> genreWidgets(List<dynamic> genres) {
    var list = List<Widget>();
    int count = genres.length > 3 ? 3 : genres.length;
    for (int i = 0; i < count; i++) {
      list.add(
        Padding(
          padding: i != 0
              ? const EdgeInsets.symmetric(horizontal: 4.0)
              : EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 0.0),
          child: Chip(
            backgroundColor: Color(0xFF1D2733),
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
    }
    return list;
  }

  String minutesToComposite(int minutes) {
    int hours = 0;
    int min = 0;
    if (minutes != null) {
      hours = (minutes / 60).floor();
      min = minutes % 60;
    }
    return '${hours}h ${min}m';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 4.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.access_time,
                color: Colors.amber,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  minutesToComposite(widget.movie.runtime),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: genreWidgets(
                widget.movie != null && widget.movie.genres != null
                    ? widget.movie.genres
                    : []),
          ),
          FutureBuilder<Movie>(
              future: MovieDatabase.db.getMovie(widget.movie.id),
              builder: (BuildContext context, AsyncSnapshot<Movie> snapshot) {
                isFavorite = snapshot.hasData && snapshot.data != null;
                return IconButton(
                  icon: snapshot.hasData && snapshot.data != null
                      ? Icon(
                          Icons.favorite,
                        )
                      : Icon(
                          Icons.favorite_border,
                        ),
                  onPressed: () async {
                    setState(
                      () {
                        isFavorite = !isFavorite;
                      },
                    );
                    if (isFavorite) {
                      MovieDatabase.db.newMovie(widget.movie);
                      saveImageToFile(widget.movie.posterPath, false);
                      saveImageToFile(widget.movie.backdropPath, true);
                    } else {
                      MovieDatabase.db.deleteMovie(widget.movie.id);
                      MovieDatabase.db.deleteMovie(widget.movie.id);
                      final backdropDir = Directory(
                          (await getApplicationDocumentsDirectory()).path +
                              widget.movie.backdropPath);
                      backdropDir.deleteSync(recursive: true);
                      final posterDir = Directory(
                          (await getApplicationDocumentsDirectory()).path +
                              widget.movie.posterPath);
                      posterDir.deleteSync(recursive: true);
                    }
                  },
                );
              }),
        ],
      ),
    );
  }
}
