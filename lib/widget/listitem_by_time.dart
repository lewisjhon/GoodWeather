import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:weather/model/view_model.dart';

class ListitemByTime extends StatelessWidget {
  final int currentTemperture;
  final String title;
  final String img;

  const ListitemByTime(
      {required this.currentTemperture,
      required this.title,
      required this.img,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 100,
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(10),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          child: Text(
            '$currentTemperture°',
            style: const TextStyle(fontSize: 12),
          ),
        ),
        Container(
          child: SvgPicture.asset(
            img,
            height: 40,
          ),
        ),
        Container(
          child: Text(title, style: const TextStyle(fontSize: 12)),
        )
      ]),
    );
  }
}
