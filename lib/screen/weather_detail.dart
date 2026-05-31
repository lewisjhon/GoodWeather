import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:weather/business/weather_cubit.dart';
import 'package:weather/business/weather_state.dart';
import 'package:weather/helper/app_theme.dart';
import 'package:weather/helper/public_function.dart';
import 'package:weather/model/domain_model.dart';
import 'package:weather/model/view_model.dart';
import 'package:weather/widget/listitem_by_day.dart';
import 'package:weather/widget/listitem_by_time.dart';
import 'package:weather/widget/outfit_widget.dart';
import 'package:weather/widget/today_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Map<String, String> UNIT_ID = kReleaseMode
    ? {
  'ios': 'ca-app-pub-4667051183270672/7132450833',
  'android': 'ca-app-pub-4667051183270672/7855425437',
}
    : {
  'ios': 'ca-app-pub-3940256099942544/2934735716',
  'android': 'ca-app-pub-3940256099942544/6300978111',
};

class WeatherDetailWidget extends StatefulWidget {
  const WeatherDetailWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherDetailWidgetState createState() => _WeatherDetailWidgetState();
}

class _WeatherDetailWidgetState extends State<WeatherDetailWidget> with WidgetsBindingObserver{

  BannerAd? banner;
  late LocationData _locationData;


  void getLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;


    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    //권한 확인
    if (_permissionGranted == PermissionStatus.denied) {
      //권한이 없으면 권한 요청.
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    Logger().d(_locationData);
  }

  void fetchData(bool isForce) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? lastReqHour = prefs.getInt('lastReqHour');

    if (lastReqHour != getDateTime().hour || isForce) {
      BlocProvider.of<WeatherCubit>(context).getWeather();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
    fetchData(true);
    getLocation();

    banner = BannerAd(
      size: AdSize.fluid,
      adUnitId: UNIT_ID[Platform.isIOS ? 'ios' : 'android']!,
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) {},
        onAdLoaded: (_) {},
      ),
      request: AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        fetchData(false);
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      locale: const Locale('ko'),
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: CupertinoColors.quaternaryLabel,
          barBackgroundColor: CupertinoColors.white,
          scaffoldBackgroundColor: CupertinoColors.white,
          ),
      home: CupertinoPageScaffold(
        child: RefreshIndicator(
          onRefresh: () async {
            fetchData(true);
          },
          child: BlocBuilder<WeatherCubit, WeatherState>(
            builder: (_, state) {
              if (state is Empty) {
                return Container();
              } else if (state is Error) {
                return Center(
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
                        padding:
                            const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        onPressed: () => fetchData(true),
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                );
              } else if (state is Loading) {
                //return const Center(child: CupertinoActivityIndicator()); // iphone style
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: CircularProgressIndicator()),
                    SizedBox(height: 20),
                    Text('날씨 정보를 불러오는 중 입니다.')
                  ],
                ); //android style
              } else if (state is Loaded) {
                final WeatherViewModel viewModel =
                    state.weather[0] as WeatherViewModel;

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
                                    style: const TextStyle(
                                        color: kTextSecondary, fontSize: 12),
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
                            child: OutfitWidget(
                                temp: viewModel.curTemperature),
                          ),
                          SliverAppBar(
                            toolbarHeight: 30,
                            backgroundColor: Colors.transparent,
                            flexibleSpace: AdWidget(
                              ad: banner!,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 20),
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
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
