import 'package:flutter/material.dart';
import 'package:weather/helper/app_theme.dart';
import 'package:weather/helper/public_function.dart';

/// 현재 기온에 맞춘 옷차림 추천 카드.
/// 이모지 + 한 줄 요약 + 추천 의상 목록을 파스텔 반투명 카드로 보여준다.
class OutfitWidget extends StatelessWidget {
  final int temp;

  const OutfitWidget({required this.temp, super.key});

  @override
  Widget build(BuildContext context) {
    final outfit = getOutfitRecommendation(temp);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kCardBorder),
      ),
      child: Row(
        children: [
          Text(outfit.emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '오늘의 옷차림',
                  style: TextStyle(fontSize: 12, color: kTextSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  outfit.summary,
                  style: const TextStyle(
                    fontSize: 15,
                    color: kTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  outfit.items,
                  style: const TextStyle(fontSize: 13, color: kTextSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
