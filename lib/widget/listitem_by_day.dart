import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather/helper/public_function.dart';
import 'package:flutter/material.dart';

class ListitemByDay extends StatelessWidget {
  final String title;
  final int min;
  final int max;

  const ListitemByDay(
      {required this.title, required this.min, required this.max, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: Colors.black12,
        )),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Container(
          child: Text(title),
        ),
        Container(
          child: SvgPicture.asset(
            getWeatherIcon('01d'),
            height: 100,
          ),
        ),
        Container(
          child: Text('$min°/$max°'),
        )
      ]),
    );
  }
}
