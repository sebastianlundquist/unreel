import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_app/models/database.dart';
import 'package:movie_app/models/movie.dart';
import 'package:path_provider/path_provider.dart';

import 'movie_screen.dart';

const baseUrl = 'https://image.tmdb.org/t/p/';
const posterWidth = 'w300';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Future<String> _loadMovieAsset() async {
    return await rootBundle.loadString('assets/shawshank.json');
  }

  Future loadMovie() async {
    String jsonString = await _loadMovieAsset();
    final jsonResponse = json.decode(jsonString);
    Movie movie = new Movie.fromJson(jsonResponse);
    MovieDatabase.db.newMovie(movie);
  }

  Future<File> _getLocalFile(String filename) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File f = new File('$dir/$filename');
    return f;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FutureBuilder<List<Movie>>(
        future: MovieDatabase.db.getAllMovies(),
        initialData: List(),
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          return snapshot.hasData && snapshot.data.length > 0
              ? GridView.builder(
                  itemCount: snapshot.data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    childAspectRatio: 2 / 3,
                  ),
                  itemBuilder: (BuildContext context, int position) {
                    Movie movie = snapshot.data[position];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieScreen(
                              movie: movie,
                            ),
                          ),
                        );
                      },
                      onLongPress: () async {
                        setState(() {
                          MovieDatabase.db.deleteMovie(movie.id);
                        });
                        final dir = Directory(
                            (await getApplicationDocumentsDirectory()).path +
                                movie.posterPath);
                        dir.deleteSync(recursive: true);
                      },
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          FutureBuilder<File>(
                            future: _getLocalFile(
                                movie.posterPath.replaceFirst('/', '')),
                            builder: (context, snapshot) =>
                                snapshot.data != null
                                    ? Image.file(snapshot.data)
                                    : Image.asset(
                                        'images/placeholder_poster_1.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 4.0),
                            child: Text(
                              movie.title,
                              style: TextStyle(shadows: <Shadow>[
                                Shadow(
                                    offset: Offset(1.0, 1.0), blurRadius: 3.0)
                              ]),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: Text('You do not have any saved movies.'),
                );
        },
      ),
    );
  }
}
