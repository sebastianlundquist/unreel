import 'package:flutter/material.dart';
import 'package:movie_app/services/movies.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/widgets/genres_bar.dart';
import 'package:movie_app/widgets/movie_description.dart';
import 'package:movie_app/models/shawshank.dart';
import 'package:movie_app/widgets/title_display.dart';

const imageURL = 'https://image.tmdb.org/t/p';
const backdropSize = '/w780';

Movie movieObject = Movie.fromJson(shawshank);
ImageProvider backdropImage = AssetImage('images/shawshank_backdrop.jpg');
dynamic discoveryListData;
int movieIndex = 0;
int page = 1;

class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  DateTime minReleaseDate = DateTime(2000, 1, 1);
  DateTime maxReleaseDate = DateTime(2010, 12, 31);
  int minVoteCount = 100;
  double minVoteAverage = 7.0;

  void updateUI(dynamic discoveryListData, int index) {
    setState(() {
      movieObject = Movie.fromJson(discoveryListData['results'][index]);
      movieIndex++;
      backdropImage =
          NetworkImage('$imageURL$backdropSize${movieObject.backdropPath}');
      if (movieIndex < 20)
        precacheImage(
            NetworkImage(
                '$imageURL$backdropSize${Movie.fromJson(discoveryListData['results'][movieIndex]).backdropPath}'),
            context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TitleDisplay(backdropImage: backdropImage, movieObject: movieObject),
        GenresBar(movieObject: movieObject),
        MovieDescription(movieObject: movieObject),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () async {
              if (movieIndex == 20) {
                movieIndex = 0;
                page++;
              }
              if (movieIndex == 0) {
                discoveryListData = await Movies().getMovies(minReleaseDate,
                    maxReleaseDate, minVoteCount, minVoteAverage, page);
              }
              updateUI(discoveryListData, movieIndex);
            },
            child: Icon(Icons.refresh),
          ),
        ),
      ],
    );
  }
}
