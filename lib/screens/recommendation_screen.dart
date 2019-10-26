import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/models/settings.dart';
import 'package:movie_app/services/movies.dart';
import 'package:movie_app/widgets/genres_bar.dart';
import 'package:movie_app/widgets/movie_description.dart';
import 'package:movie_app/models/shawshank.dart';
import 'package:movie_app/widgets/title_display.dart';
import 'package:provider/provider.dart';

const imageURL = 'https://image.tmdb.org/t/p';
const backdropSize = '/w780';

Movie actualMovie = Movie.fromJson(shawshank);
Movie nextMovie = Movie.fromJson(shawshank);
ImageProvider backdropImage = AssetImage('images/shawshank_backdrop.jpg');
dynamic discoveryListData;
int movieIndex = 0;
int page = 1;
int resultsPerPage = 20;
var movieList = new List<int>();

void resetMovies() {
  movieIndex = 0;
  page = 1;
  discoveryListData = null;
  actualMovie = Movie.fromJson(shawshank);
  nextMovie = Movie.fromJson(shawshank);
}

class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  void preloadNextMovie() async {
    precacheImage(
        NetworkImage(
            '$imageURL$backdropSize${Movie.fromJson(discoveryListData['results'][movieIndex]).backdropPath}'),
        context);
    nextMovie = await Movies().getMovieDetails(movieList[movieIndex]);
  }

  void init(Settings settings) async {
    if (discoveryListData == null) {
      discoveryListData = 0;
      discoveryListData = await Movies().getMovies(
          settings.genre['id'],
          settings.minRating,
          settings.minVotes,
          DateTime.utc(settings.yearSpan.start.toInt(), 1, 1),
          DateTime.utc(settings.yearSpan.end.toInt(), 12, 31),
          page);
      movieList.clear();
      if (discoveryListData == null) {
        print(discoveryListData.toString());
        actualMovie = Movie.fromJson(shawshank);
        backdropImage = AssetImage('images/shawshank_backdrop.jpg');
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('No movies found! :('),
          ),
        );
      } else {
        print(discoveryListData.toString());
        for (var movie in discoveryListData['results'])
          movieList.add(movie['id']);
        preloadNextMovie();
      }
    }
  }

  void goToNextMovie(Settings settings) async {
    if (movieIndex != resultsPerPage - 1) {
      setState(() {
        actualMovie = nextMovie;
        backdropImage =
            NetworkImage('$imageURL$backdropSize${actualMovie.backdropPath}');
      });
      movieIndex++;
    } else {
      setState(() {
        actualMovie = nextMovie;
        backdropImage =
            NetworkImage('$imageURL$backdropSize${actualMovie.backdropPath}');
      });
      movieIndex = 0;
      page++;
      discoveryListData = await Movies().getMovies(
          settings.genre['id'],
          settings.minRating,
          settings.minVotes,
          DateTime.utc(settings.yearSpan.start.toInt(), 1, 1),
          DateTime.utc(settings.yearSpan.end.toInt(), 12, 31),
          page);
      movieList.clear();
      if (discoveryListData == null) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('No movies found! :('),
          ),
        );
      } else {
        for (var movie in discoveryListData['results'])
          movieList.add(movie['id']);
      }
    }
    preloadNextMovie();
  }

  @override
  Widget build(BuildContext context) {
    init(Provider.of<Settings>(context));
    return Column(
      children: <Widget>[
        TitleDisplay(backdropImage: backdropImage, movieObject: actualMovie),
        GenresBar(movieObject: actualMovie),
        MovieDescription(movieObject: actualMovie),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () {
              goToNextMovie(Provider.of<Settings>(context));
            },
            child: Icon(Icons.refresh),
          ),
        ),
      ],
    );
  }
}
