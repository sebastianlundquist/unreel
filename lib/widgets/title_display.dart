import 'dart:io';

import 'package:flutter/material.dart';
import 'package:unreel/models/movie.dart';
import 'package:unreel/widgets/title_bar.dart';
import 'package:path_provider/path_provider.dart';

class TitleDisplay extends StatelessWidget {
  final Movie movie;
  final bool isSaved;
  TitleDisplay({@required this.movie, @required this.isSaved});
  Future<File> _getLocalFile(String filename) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File f = new File('$dir/$filename');
    if (f.existsSync()) return f;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        ShaderMask(
          child: isSaved
              ? FutureBuilder<File>(
                  future:
                      _getLocalFile(movie.backdropPath.replaceFirst('/', '')),
                  builder: (context, snapshot) =>
                      snapshot != null && snapshot.data != null
                          ? Image.file(snapshot.data)
                          : Image.asset('images/transparent_backdrop.png'),
                )
              : FadeInImage(
                  image: NetworkImage(
                      'https://image.tmdb.org/t/p/w780' + movie.backdropPath),
                  placeholder: AssetImage('images/transparent_backdrop.png'),
                ),
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x00000000), Color(0xFF131C25)],
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
          child: TitleBar(movie: movie),
        ),
      ],
    );
  }
}
