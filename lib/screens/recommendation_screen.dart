import 'package:flutter/material.dart';
import 'package:movie_app/services/movies.dart';
import 'package:movie_app/models/movie.dart';

class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  int minReleaseDate = 2000;
  int maxReleaseDate = 2010;
  int minVoteCount = 100;
  double minVoteAverage = 7.0;
  dynamic movieData;
  Movie movieObject;
  int movieIndex = 0;

  String title;
  String description;

  void updateUI(dynamic movieData, int index) {
    setState(() {
      movieObject = Movie.fromJson(movieData);
      movieIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(movieObject != null ? movieObject.title : ''),
                      Text(movieObject != null ? movieObject.overview : ''),
                    ],
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    child: Text('Get Movies'),
                    onPressed: () async {
                      if (movieIndex == 0) {
                        movieData = await Movies().getMovies(minReleaseDate,
                            maxReleaseDate, minVoteCount, minVoteAverage);
                      } else if (movieIndex == 20) {
                        movieIndex = 0;
                      }
                      updateUI(movieData, movieIndex);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
