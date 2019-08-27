import 'package:flutter/material.dart';
import 'package:movie_app/services/movies.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/components/star_display.dart';
import 'package:movie_app/models/shawshank.dart';
import 'package:movie_app/models/languages.dart';
import 'package:movie_app/models/genres.dart';

const imageURL = 'https://image.tmdb.org/t/p';
const backdropSize = '/w780';

Movie movieObject = Movie.fromJson(shawshank);
ImageProvider backdropImage = AssetImage('images/shawshank_backdrop.jpg');
dynamic movieData;
int movieIndex = 0;
int page = 1;
bool isFavorite = false;

class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  DateTime minReleaseDate = DateTime(2000, 1, 1);
  DateTime maxReleaseDate = DateTime(2010, 12, 31);
  int minVoteCount = 100;
  double minVoteAverage = 7.0;

  String title;
  String description;

  void updateUI(dynamic movieData, int index) {
    setState(() {
      movieObject = Movie.fromJson(movieData['results'][index]);
      movieIndex++;
      backdropImage =
          NetworkImage('$imageURL$backdropSize${movieObject.backdropPath}');
      if (movieIndex < 20)
        precacheImage(
            NetworkImage(
                '$imageURL$backdropSize${Movie.fromJson(movieData['results'][movieIndex]).backdropPath}'),
            context);
    });
  }

  List<Widget> genreWidgets(List<dynamic> ids) {
    var list = List<Widget>();
    int count = ids.length > 3 ? 3 : ids.length;
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
              getGenreNameFromId(ids[i]),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            ShaderMask(
              child: FadeInImage(
                placeholder: AssetImage('images/transparent_backdrop.png'),
                image: backdropImage,
              ),
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00000000), Color(0xFF37474F)],
                  stops: [
                    0.5,
                    1.0,
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          movieObject != null ? movieObject.title : '',
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
                                    value: movieObject != null
                                        ? movieObject.voteAverage
                                        : 5),
                              ),
                              Text(
                                movieObject != null
                                    ? movieObject.voteCount.toString() +
                                        ' votes'
                                    : '',
                                style: Theme.of(context).textTheme.subtitle,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            movieObject != null
                                ? movieObject.voteAverage.toString()
                                : '',
                            style: Theme.of(context).textTheme.display1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: genreWidgets(
                    movieObject != null && movieObject.genreIds != null
                        ? movieObject.genreIds
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
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(0.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  movieObject != null ? movieObject.overview : '',
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('Original Title:'),
                        ),
                        Expanded(
                          child: Text(movieObject != null
                              ? movieObject.originalTitle
                              : ''),
                          flex: 2,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('Genres:'),
                        ),
                        Expanded(
                          child: Text(movieObject != null &&
                                  movieObject.genreIds != null
                              ? getGenreNamesFromIdList(movieObject.genreIds)
                                  .join(', ')
                              : ''),
                          flex: 2,
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('Release Date:'),
                        ),
                        Expanded(
                          child: Text(movieObject != null
                              ? movieObject.releaseDate.toString()
                              : ''),
                          flex: 2,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('Original Language:'),
                        ),
                        Expanded(
                          child: Text(movieObject != null
                              ? findLanguage(movieObject.originalLanguage)
                              : ''),
                          flex: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () async {
              if (movieIndex == 20) {
                movieIndex = 0;
                page++;
              }
              if (movieIndex == 0) {
                movieData = await Movies().getMovies(minReleaseDate,
                    maxReleaseDate, minVoteCount, minVoteAverage, page);
              }
              updateUI(movieData, movieIndex);
            },
            child: Icon(Icons.refresh),
          ),
        ),
      ],
    );
  }
}
