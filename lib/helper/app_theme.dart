import 'package:flutter/material.dart';

/// 파스텔톤 색상 팔레트와 텍스트 색상 모음.
///
/// 아이폰 기본 날씨 앱 느낌의 부드러운 그라데이션 배경을 현재 기온에 따라
/// 골라 주는 [getPastelGradient] 가 핵심이다. UI 위젯들은 색상을 직접
/// 박아 넣지 말고 여기 상수를 참조한다.

/// 파스텔 배경 위에서 잘 읽히는 진한 슬레이트 색.
const Color kTextPrimary = Color(0xFF3D3D52);

/// 보조 텍스트(라벨, 설명)용 옅은 색.
const Color kTextSecondary = Color(0xFF7A7A90);

/// 배경 위에 얹는 반투명 카드 색.
const Color kCardColor = Color(0x40FFFFFF);

/// 카드 테두리(은은한 흰색).
const Color kCardBorder = Color(0x55FFFFFF);

/// 현재 기온대에 어울리는 파스텔 그라데이션(위 → 아래)을 돌려준다.
/// 더울수록 따뜻한 코랄/살구, 선선하면 민트, 추우면 하늘/라벤더 계열.
List<Color> getPastelGradient(int temp) {
  if (temp >= 28) {
    return const [Color(0xFFFFB7A8), Color(0xFFFFE3D2)]; // 더움 - 코랄/피치
  } else if (temp >= 23) {
    return const [Color(0xFFFFD3A8), Color(0xFFFFF0DC)]; // 따뜻 - 살구
  } else if (temp >= 17) {
    return const [Color(0xFFBEE7C8), Color(0xFFE6F7EA)]; // 선선 - 민트
  } else if (temp >= 10) {
    return const [Color(0xFFAFD4ED), Color(0xFFE1F1FB)]; // 쌀쌀 - 하늘
  } else {
    return const [Color(0xFFC3B8E8), Color(0xFFEAE2F8)]; // 추움 - 라벤더
  }
}
