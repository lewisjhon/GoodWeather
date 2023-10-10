import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class TodayWidget extends StatelessWidget {
  final String title;
  final String img;
  final int min;
  final int max;
  final int now;

  const TodayWidget(
      {required this.title,
      required this.img,
      required this.min,
      required this.max,
      required this.now,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text(
              title,
              style: TextStyle(fontSize: 30),
            ),
          ),
          Container(
            child: SvgPicture.asset(img, height: 150),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('최저'), Text('${min.toString()}°')],
                  )),
              Container(
                alignment: Alignment.center,
                width: 100,
                child: Text('${now.toString()}°',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              Container(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('최고'), Text('${max.toString()}°')],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
