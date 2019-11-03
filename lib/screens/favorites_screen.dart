import 'dart:io';

import 'package:flutter/material.dart';

import 'package:unreel/models/database.dart';
import 'package:unreel/models/movie.dart';
import 'package:unreel/screens/movie_screen.dart';
import 'package:unreel/services/files.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
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
                            builder: (context) => MovieScreen(movie: movie),
                          ),
                        );
                      },
                      onLongPress: () async {
                        setState(() {
                          MovieDatabase.db.deleteMovie(movie.id);
                        });
                        Files.deleteImage(movie.posterPath);
                        Files.deleteImage(movie.backdropPath);
                      },
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          FutureBuilder<File>(
                            future: Files.getLocalFile(
                                movie.posterPath.replaceFirst('/', '')),
                            builder: (context, snapshot) =>
                                snapshot.data != null
                                    ? Image.file(snapshot.data)
                                    : Image.asset(
                                        'images/placeholder_poster_1.png'),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Center(child: Text('You do not have any saved movies.'));
        },
      ),
    );
  }
}
