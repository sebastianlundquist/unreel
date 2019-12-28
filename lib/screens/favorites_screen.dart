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
                      onLongPress: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Color(0xFF131C25),
                                elevation: 0.0,
                                title: Text('Remove'),
                                content: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(text: 'Do you want to remove '),
                                      TextSpan(
                                        text: '${movie.title}',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.amber),
                                      ),
                                      TextSpan(text: ' from your saved movies?')
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      setState(() {
                                        MovieDatabase.db.deleteMovie(movie.id);
                                      });
                                      if (movie.posterPath != null &&
                                          movie.posterPath.isNotEmpty)
                                        Files.deleteImage(movie.posterPath);
                                      if (movie.backdropPath != null &&
                                          movie.backdropPath.isNotEmpty)
                                        Files.deleteImage(movie.backdropPath);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      },
                      child: FutureBuilder<File>(
                        future: Files.getLocalFile(
                            movie.posterPath.replaceFirst('/', '')),
                        builder: (context, snapshot) => snapshot.data != null
                            ? Stack(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(snapshot.data),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Material(
                                    type: MaterialType.transparency,
                                    child: Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: FlatButton(
                                        child: null,
                                        highlightColor: Color(0xaa000000),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MovieScreen(movie: movie),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'images/placeholder_poster_1.png'),
                                  ),
                                ),
                              ),
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
