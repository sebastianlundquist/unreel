import 'package:flutter/material.dart';

class StarDisplay extends StatelessWidget {
  final double value;
  const StarDisplay({Key key, this.value = 0})
      : assert(value != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          convert(index),
        );
      }),
    );
  }

  IconData convert(int index) {
    if (value.floor() < 2 * index) {
      return Icons.star_border;
    } else if (value.floor() > 2 * index && value.floor() < 2 * (index + 1)) {
      return Icons.star_half;
    } else if (value.floor() >= 2 * (index + 1)) {
      return Icons.star;
    }
    return Icons.star_border;
  }
}
