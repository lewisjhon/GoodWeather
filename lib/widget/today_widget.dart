import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather/helper/app_theme.dart';
import 'package:weather/helper/public_function.dart';

/// 아이폰 기본 날씨 앱 상단부를 닮은 헤더.
/// 지역 → 날씨 아이콘 → 큰 현재 기온 → 상태 → 최고/최저 → 어제 비교 순.
class TodayWidget extends StatelessWidget {
  final String title; // 지역명
  final String img;
  final int min;
  final int max;
  final int now;
  final String condition; // 맑음/흐림/비 등
  final int? yesterday; // 어제 같은 시각 기온(없으면 null)

  const TodayWidget({
    required this.title,
    required this.img,
    required this.min,
    required this.max,
    required this.now,
    required this.condition,
    this.yesterday,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final comparison = getYesterdayComparisonText(now, yesterday);

    return Container(
      padding: const EdgeInsets.only(top: 44),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              color: kTextPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          SvgPicture.asset(img, height: 76),
          Text(
            '$now°',
            style: const TextStyle(
              fontSize: 68,
              color: kTextPrimary,
              fontWeight: FontWeight.w200,
              height: 1.1,
            ),
          ),
          Text(
            condition,
            style: const TextStyle(fontSize: 18, color: kTextSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            '최고 $max°   최저 $min°',
            style: const TextStyle(fontSize: 15, color: kTextSecondary),
          ),
          if (comparison.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              comparison,
              style: const TextStyle(
                fontSize: 14,
                color: kTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
