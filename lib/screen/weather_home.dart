import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:weather/business/location_store.dart';
import 'package:weather/business/weather_cubit.dart';
import 'package:weather/helper/app_theme.dart';
import 'package:weather/helper/regions.dart';
import 'package:weather/model/region.dart';
import 'package:weather/repository/api/k_weather.dart';
import 'package:weather/screen/weather_detail.dart';
import 'package:weather/widget/region_search_sheet.dart';

/// 앱의 최상위 화면.
/// 0번 페이지는 GPS 현재 위치, 그 뒤는 사용자가 추가한 지역들이며 좌우로
/// 스와이프해서 넘긴다. 지역별 [WeatherCubit] 을 하나씩 들고 있어 페이지를
/// 오가도 이미 받아 둔 날씨가 유지된다.
class WeatherHomeWidget extends StatefulWidget {
  const WeatherHomeWidget({super.key});

  @override
  State<WeatherHomeWidget> createState() => _WeatherHomeWidgetState();
}

class _WeatherHomeWidgetState extends State<WeatherHomeWidget>
    with WidgetsBindingObserver {
  final WeatherRepository _repository = WeatherRepository();
  final LocationStore _store = LocationStore();
  final Map<String, WeatherCubit> _cubits = {};
  final PageController _pageController = PageController();

  Region? _current; // GPS 로 잡은 현재 위치
  List<Region> _saved = [];
  bool _ready = false;
  int _pageIndex = 0;

  List<Region> get _pages => [
        if (_current != null) _current!,
        ..._saved,
      ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (final c in _cubits.values) {
      c.close();
    }
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    final saved = await _store.load();
    final current = await _resolveCurrentRegion();
    if (!mounted) return;
    setState(() {
      _saved = saved;
      _current = current;
      _ready = true;
    });
  }

  /// GPS 권한/좌표를 얻어 현재 위치 [Region] 을 만든다.
  /// 서비스 비활성·권한 거부·실패 시 서울 기본값으로 폴백한다.
  Future<Region> _resolveCurrentRegion() async {
    try {
      final location = Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return kDefaultRegion.copyWith(isCurrent: true);
      }

      PermissionStatus permission = await location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await location.requestPermission();
        if (permission != PermissionStatus.granted) {
          return kDefaultRegion.copyWith(isCurrent: true);
        }
      }

      final data = await location.getLocation();
      if (data.latitude == null || data.longitude == null) {
        return kDefaultRegion.copyWith(isCurrent: true);
      }
      return regionFromGps(data.latitude!, data.longitude!);
    } catch (e) {
      Logger().d('위치 조회 실패, 기본값 사용: $e');
      return kDefaultRegion.copyWith(isCurrent: true);
    }
  }

  /// 지역별 cubit 을 한 번만 만들어 캐시하고, 생성 시 첫 조회를 건다.
  WeatherCubit _cubitFor(Region region) {
    return _cubits.putIfAbsent(region.key, () {
      final cubit = WeatherCubit(repository: _repository);
      cubit.getWeather(region);
      return cubit;
    });
  }

  void _addRegion(Region region) {
    final pages = _pages;
    final existing = pages.indexWhere((r) => r.key == region.key);
    if (existing >= 0) {
      _goToPage(existing);
      return;
    }
    setState(() {
      _saved = [..._saved, region];
    });
    _store.save(_saved);
    _goToPage(_pages.length - 1);
  }

  void _removeRegion(Region region) {
    _cubits.remove(region.key)?.close();
    setState(() {
      _saved = _saved.where((r) => r.key != region.key).toList();
      if (_pageIndex >= _pages.length) {
        _pageIndex = _pages.isEmpty ? 0 : _pages.length - 1;
      }
    });
    _store.save(_saved);
  }

  void _goToPage(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    setState(() => _pageIndex = index);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _pages.isNotEmpty) {
      final idx = _pageIndex < _pages.length ? _pageIndex : _pages.length - 1;
      final region = _pages[idx];
      // throttle 이 시각당 1회만 실제 호출하도록 판단한다.
      _cubitFor(region).getWeather(region);
    }
  }

  void _openSearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RegionSearchSheet(
        saved: _saved,
        onAdd: _addRegion,
        onRemove: _removeRegion,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ko', 'KR')],
      locale: const Locale('ko'),
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.quaternaryLabel,
        barBackgroundColor: CupertinoColors.white,
        scaffoldBackgroundColor: CupertinoColors.white,
      ),
      home: CupertinoPageScaffold(
        child: _ready ? _buildPager() : _buildSplash(),
      ),
    );
  }

  Widget _buildSplash() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: getPastelGradient(15),
        ),
      ),
      child: const Center(child: CircularProgressIndicator(color: kTextPrimary)),
    );
  }

  Widget _buildPager() {
    final pages = _pages;
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: pages.length,
          onPageChanged: (i) => setState(() => _pageIndex = i),
          itemBuilder: (_, i) {
            final region = pages[i];
            return BlocProvider.value(
              value: _cubitFor(region),
              child: WeatherDetailWidget(
                key: ValueKey(region.key),
                region: region,
              ),
            );
          },
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const SizedBox(width: 44),
                  Expanded(child: _buildDots(pages)),
                  SizedBox(
                    width: 44,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _openSearch,
                      child: const Icon(CupertinoIcons.list_bullet,
                          color: kTextPrimary, size: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDots(List<Region> pages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < pages.length; i++)
          if (i == 0 && pages[i].isCurrent)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Icon(
                CupertinoIcons.location_solid,
                size: 11,
                color: i == _pageIndex
                    ? kTextPrimary
                    : kTextSecondary.withOpacity(0.4),
              ),
            )
          else
            Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == _pageIndex
                    ? kTextPrimary
                    : kTextSecondary.withOpacity(0.4),
              ),
            ),
      ],
    );
  }
}
