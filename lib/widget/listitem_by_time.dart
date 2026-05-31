import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:weather/helper/app_theme.dart';

/// 시간 별 예보 가로 스크롤의 한 칸: 시각 → 아이콘 → 기온.
class ListitemByTime extends StatelessWidget {
  final int currentTemperture;
  final String title;
  final String img;

  const ListitemByTime({
    required this.currentTemperture,
    required this.title,
    required this.img,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: kTextSecondary),
          ),
          const SizedBox(height: 6),
          SvgPicture.asset(img, height: 34),
          const SizedBox(height: 6),
          Text(
            '$currentTemperture°',
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
