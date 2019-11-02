import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_app/models/database.dart';
import 'package:movie_app/models/movie.dart';

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: MovieDatabase.db.getAllMovies(),
      initialData: List(),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int position) {
                  Movie movie = snapshot.data[position];
                  return Card(
                    child: ListTile(
                      title: Text(movie.title),
                    ),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
