import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class ListitemByTime extends StatelessWidget {
  final int currentTemperture;

  const ListitemByTime({required this.currentTemperture, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 100,
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(10),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          child: Text('$currentTemperture도'),
        ),
        Container(
          child: SvgPicture.asset(
            'assets/images/cloudy_day.svg',
            height: 40,
          ),
        ),
        Container(
          child: const Text('10도'),
        )
      ]),
    );
  }
}
