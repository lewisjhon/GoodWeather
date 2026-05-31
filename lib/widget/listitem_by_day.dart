import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:weather/helper/app_theme.dart';

/// 주간 예보 한 줄: 요일/날짜 · 날씨 아이콘 · 최저/최고 기온.
class ListitemByDay extends StatelessWidget {
  final String title;
  final String img;
  final int min;
  final int max;

  const ListitemByDay({
    required this.title,
    required this.img,
    required this.min,
    required this.max,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, color: kTextPrimary),
            ),
          ),
          SvgPicture.asset(img, height: 30),
          const Spacer(),
          Text(
            '$min°',
            style: const TextStyle(fontSize: 15, color: kTextSecondary),
          ),
          const SizedBox(width: 14),
          Text(
            '$max°',
            style: const TextStyle(
              fontSize: 15,
              color: kTextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
