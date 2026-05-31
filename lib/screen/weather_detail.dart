import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:weather/business/weather_cubit.dart';
import 'package:weather/business/weather_state.dart';
import 'package:weather/helper/app_theme.dart';
import 'package:weather/helper/public_function.dart';
import 'package:weather/model/region.dart';
import 'package:weather/model/view_model.dart';
import 'package:weather/widget/listitem_by_day.dart';
import 'package:weather/widget/listitem_by_time.dart';
import 'package:weather/widget/outfit_widget.dart';
import 'package:weather/widget/today_widget.dart';

const Map<String, String> UNIT_ID = kReleaseMode
    ? {
        'ios': 'ca-app-pub-4667051183270672/7132450833',
        'android': 'ca-app-pub-4667051183270672/7855425437',
      }
    : {
        'ios': 'ca-app-pub-3940256099942544/2934735716',
        'android': 'ca-app-pub-3940256099942544/6300978111',
      };

/// 한 지역의 날씨 페이지. [WeatherCubit] 은 상위 [WeatherHomeWidget] 이
/// 지역별로 만들어 `BlocProvider.value` 로 주입한다(스와이프해도 상태 유지).
class WeatherDetailWidget extends StatefulWidget {
  final Region region;

  const WeatherDetailWidget({required this.region, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherDetailWidgetState createState() => _WeatherDetailWidgetState();
}

class _WeatherDetailWidgetState extends State<WeatherDetailWidget> {
  BannerAd? banner;

  @override
  void initState() {
    super.initState();

    banner = BannerAd(
      size: AdSize.fluid,
      adUnitId: UNIT_ID[Platform.isIOS ? 'ios' : 'android']!,
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) {},
        onAdLoaded: (_) {},
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    banner?.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await context.read<WeatherCubit>().getWeather(widget.region, force: true);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (_, state) {
          if (state is Error) {
            return _ErrorView(onRetry: _refresh);
          } else if (state is Loading || state is Empty) {
            return const _LoadingView();
          } else if (state is Loaded) {
            final WeatherViewModel viewModel =
                state.weather[0] as WeatherViewModel;
            return _buildLoaded(viewModel);
          }
          return const _LoadingView();
        },
      ),
    );
  }

  Widget _buildLoaded(WeatherViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: getPastelGradient(viewModel.curTemperature),
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: false,
            stretch: true,
            centerTitle: false,
            toolbarHeight: 60.0,
            expandedHeight: 340.0,
            flexibleSpace: FlexibleSpaceBar(
              background: TodayWidget(
                img: viewModel.weatherImage,
                title: viewModel.region,
                now: viewModel.curTemperature,
                min: viewModel.minTemperature,
                max: viewModel.maxTemperature,
                condition: viewModel.weatherCondition,
                yesterday: viewModel.yesterdayTemperature,
              ),
            ),
          ),
          SliverAppBar(
            toolbarHeight: 127,
            backgroundColor: Colors.transparent,
            elevation: 0,
            stretch: false,
            pinned: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: kCardBorder),
              ),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Column(
                children: [
                  Text(
                    '${getToday()} 시간 별 예보',
                    style: const TextStyle(color: kTextSecondary, fontSize: 12),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var item in viewModel.itemByTime)
                          ListitemByTime(
                            currentTemperture: item.curTemperature,
                            title: "${item.time}시",
                            img: item.weatherImage,
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: OutfitWidget(temp: viewModel.curTemperature),
          ),
          SliverAppBar(
            toolbarHeight: 30,
            backgroundColor: Colors.transparent,
            flexibleSpace: AdWidget(ad: banner!),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 70),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kCardBorder),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      '주간 예보',
                      style: TextStyle(
                        fontSize: 13,
                        color: kTextSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  for (var item in viewModel.itemByDay)
                    ListitemByDay(
                      title: item.title,
                      img: item.weatherImage,
                      min: item.minTemperature,
                      max: item.maxTemperature,
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: getPastelGradient(15),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(color: kTextPrimary),
            SizedBox(height: 20),
            Text('날씨 정보를 불러오는 중 입니다.',
                style: TextStyle(color: kTextPrimary)),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final Future<void> Function() onRetry;

  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: getPastelGradient(15),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('☁️', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            const Text(
              '날씨 정보를 불러오지 못했어요.',
              style: TextStyle(fontSize: 16, color: kTextPrimary),
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              color: kTextPrimary,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              onPressed: onRetry,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}
