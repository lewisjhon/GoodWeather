# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

GoodWeather (package name `weather`, display name "좋은 날씨") is a Flutter mobile app
that shows Korean weather forecasts. It consumes the Korea Meteorological Administration
(기상청 / KMA) public data APIs from `data.go.kr`, renders an iOS-styled (Cupertino) UI,
and monetizes with Google AdMob banners. The app is Korean-locale only (`ko_KR`).

Dart SDK constraint: `>=2.18.5 <3.0.0` (this is a pre-Dart-3 / pre-null-safety-3 codebase).

## Commands

```bash
flutter pub get                 # Install dependencies (run after editing pubspec.yaml)
flutter run                     # Run on a connected device/emulator (debug)
flutter run --release           # Run release build (switches to production AdMob unit IDs)
flutter analyze                 # Static analysis / lint (flutter_lints rules)
flutter build apk               # Build Android APK
flutter build ios               # Build iOS (run from macOS)
flutter clean                   # Clear build cache when builds behave oddly
```

There is **no `test/` directory and no test suite**. `flutter_test` is declared but unused.
If you add tests, run them with `flutter test` (single test: `flutter test test/foo_test.dart`).

## Architecture

The app follows a layered Cubit (flutter_bloc) flow. The entire data path runs once on a
single screen — there is no routing/navigation. Read these layers together to understand a
change, since data is transformed across all of them:

```
WeatherRepository (lib/repository/api/k_weather.dart)
  → 4 HTTP calls to KMA → ResponseShort / ResponseMid (lib/model/domain_model.dart)
WeatherCubit (lib/business/weather_cubit.dart)
  → orchestrates the fetches, emits WeatherState
mapper.dart (lib/business/mapper.dart)
  → mapResponse() converts domain models → WeatherViewModel (lib/model/view_model.dart)
WeatherDetailWidget (lib/screen/weather_detail.dart)
  → BlocBuilder renders the single screen + widgets in lib/widget/
```

### State machine

`WeatherState` (lib/business/weather_state.dart) is an `Equatable` sealed-style hierarchy:
`Empty → Loading → Loaded | Error`. The cubit emits `Loaded(weather: [WeatherViewModel])` —
note `weather` is a `List<Object>`, so the UI casts `state.weather[0] as WeatherViewModel`.

### The KMA API calls (all in `WeatherRepository`)

The forecast is stitched together from separate endpoints because no single KMA
endpoint covers the full 10-day range:

- `fetchWeatherShort()` — `getVilageFcst` (단기예보), today → 3 days, hourly. Returns
  `ResponseShort` with a flat list of `ItemShort` rows keyed by `category` (TMP/SKY/PTY/REH),
  `fcstDate`, and `fcstTime`. Values are extracted by filtering this list.
- `fetchWeatherMidTemp()` — `getMidTa` (중기기온), days 4–10, min/max temps (`taMinN`/`taMaxN`).
- `fetchWeatherMidSky()` — `getMidLandFcst` (중기육상), days 4–10, sky text (`wfNAm` etc.).
- `fetchWeatherYesterday()` — `getVilageFcst` pinned to **two days ago** + `base_time=2300`,
  so the forecast window covers all of yesterday. Used only to read yesterday's temperature
  at the current hour for the "어제보다 N° 높아요/낮아요" comparison. This is best-effort:
  KMA may return NO_DATA for an old `base_date`, in which case the comparison is silently
  hidden. The cubit wraps this call in its own try/catch so a failure never blocks the load.

`mapResponse(short, mid, midSky, {yesterday})` merges them: days 0–2 come from the short list
(via `CreateDayItemFromList` filtering `category == "TMP"`), days 3–10 come from the mid
responses (`CreateDayItem` reading the `taMinN`/`wfN` fields). The hourly strip iterates a
hardcoded 24-entry `timeList` ('0000'..'2300'). Yesterday's temp is pulled via `_safeShortTemp`
(returns null instead of throwing when the row is missing).

### Caller-controlled coordinates and region are hardcoded

Several values in `mapResponse` and the repository are **fixed constants, not derived from
GPS** — be aware when "the location is wrong":
- `nx=58&ny=125` and `regId=11B10101` / `11B00000` are hardcoded (Seoul / 서울시 구로구).
- `region` string and `weatherDesc` in the returned `WeatherViewModel` are literal strings.
- GPS (`getLocation()` in weather_detail.dart) is fetched and logged but **not yet wired into
  the API requests**.

### Fetch throttling

To stay within KMA rate limits the app fetches **at most once per clock hour**. `fetchWeatherMidTemp()`
writes the current hour to `SharedPreferences['lastReqHour']`; `fetchData(isForce)` in the
screen skips the fetch if `lastReqHour == current hour` unless forced. Forced fetches happen
on `initState`, on app resume (`didChangeAppLifecycleState`), and on pull-to-refresh
(`RefreshIndicator`). KMA `getVilageFcst` only publishes 8 base times/day (02:20, 05:20, …,
23:20); `fetchWeatherShort` currently pins `base_date` to yesterday + `base_time=2300`.

### Weather icon mapping

Icons are SVGs in `assets/images/`. Two resolvers in `lib/helper/public_function.dart`:
- `getWeatherIcon(skyCode, rainCode)` — combines KMA numeric codes (`SKY`+`PTY`) into a
  string key (e.g. `'10'`, `'31'`) and switches to an asset path. Used for short-term data.
- `getWeatherIconByText(text)` — maps Korean sky text ('맑음'/'구름많음'/'흐림') to an asset.
  Used for mid-term data which only provides text.

### Pastel theme, outfit recommendation & "vs yesterday" UX

The UI mimics the iOS stock Weather app but in soft pastel tones, and adds two
Korean-context features. The pieces:

- `lib/helper/app_theme.dart` — central color palette. `getPastelGradient(temp)` picks a
  soft top→bottom gradient by temperature band (coral/peach when hot → mint → sky → lavender
  when cold); the screen's root `Container` uses it as the background (the old
  `background.jpg` image is no longer used). `kTextPrimary`/`kTextSecondary`/`kCardColor`/
  `kCardBorder` are the shared text + translucent-card colors — **use these, don't hardcode
  `Colors.black12` etc.**
- Outfit recommendation — `getOutfitRecommendation(temp)` in `public_function.dart` returns an
  `OutfitRecommendation` (emoji + one-line summary + item list) using the standard Korean
  temperature-band clothing guide. Rendered by `lib/widget/outfit_widget.dart` (a `SliverToBoxAdapter`
  card between the hourly strip and the daily list).
- "어제보다" comparison — `getYesterdayComparisonText(today, yesterday)` builds the friendly
  diff string (empty when `yesterday` is null, so the line hides itself). Shown in `TodayWidget`.
- `getWeatherConditionText(skyCode, rainCode)` — one-line Korean condition (맑음/흐림/비…) shown
  under the big current temperature, derived from the same SKY/PTY codes as the icon.

`WeatherViewModel` carries the extra `weatherCondition` (String) and `yesterdayTemperature`
(nullable `int?`) fields that drive these.

### Date helpers

All date/time formatting lives in `lib/helper/public_function.dart` (`getYYYYMMDD`, `getHH00`,
`getWeekdayWithDate`, etc.), built on `intl` with the `'ko'` locale. Prefer these over inline
`DateFormat` so the locale and offset-day (`addDay`) conventions stay consistent.

## Conventions

- **Package imports**: always `package:weather/...` (not relative). Match existing files.
- **Logging**: uses the `logger` package — `Logger().d(...)`. There are also stray
  `print()` calls in lifecycle handlers; prefer `Logger` for new code.
- **UI framework**: Cupertino (`CupertinoApp`/`CupertinoPageScaffold`), not MaterialApp,
  even though Material widgets (e.g. `RefreshIndicator`, `CircularProgressIndicator`) are
  mixed in. The single screen is built from stacked `SliverAppBar`s in a `CustomScrollView`.
- **Custom font**: "ONE Mobile Title" (TTFs in `assets/fonts/`) is registered in pubspec.
- **Naming**: factory helpers in mapper.dart use PascalCase (`CreateDayItem`) — non-standard
  for Dart but consistent within the file; follow the local pattern when editing it.

## AdMob

Ad unit IDs live in `lib/screen/weather_detail.dart` (`UNIT_ID` map) and switch on
`kReleaseMode`: Google's public test IDs in debug, real IDs in release. The Android AdMob
**app** ID is in `android/app/src/main/AndroidManifest.xml` (`com.google.android.gms.ads.APPLICATION_ID`).
`MobileAds.instance.initialize()` is called in `main()`. A single banner is loaded in
`initState` and placed inside a `SliverAppBar`.

## Known rough edges (don't treat as intentional design)

- The KMA `apikey` is **committed as a plaintext constant** in `k_weather.dart`. Don't add
  more secrets this way; if asked to fix, move it out of source.
- Android manifest has a typo permission `GOREGROUND_SERVICE` (intended `FOREGROUND_SERVICE`).
- Android package id is still the template default `com.example.weather`.
