import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/widgets/title_bar.dart';

class TitleDisplay extends StatelessWidget {
  TitleDisplay({@required this.backdropImage, @required this.movieObject});
  final ImageProvider backdropImage;
  final Movie movieObject;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
          child: TitleBar(movieObject: movieObject),
        ),
      ],
    );
  }
}
