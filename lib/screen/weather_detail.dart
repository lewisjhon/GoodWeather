import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:weather/business/weather_cubit.dart';
import 'package:weather/business/weather_state.dart';
import 'package:weather/helper/public_function.dart';
import 'package:weather/model/domain_model.dart';
import 'package:weather/model/view_model.dart';
import 'package:weather/widget/listitem_by_day.dart';
import 'package:weather/widget/listitem_by_time.dart';
import 'package:weather/widget/today_widget.dart';

class WeatherDetailWidget extends StatefulWidget {
  const WeatherDetailWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherDetailWidgetState createState() => _WeatherDetailWidgetState();
}

class _WeatherDetailWidgetState extends State<WeatherDetailWidget> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WeatherCubit>(context).getWeather();
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
          primaryColor: CupertinoColors.white,
          barBackgroundColor: CupertinoColors.white,
          scaffoldBackgroundColor: CupertinoColors.white,
          textTheme: CupertinoTextThemeData(
              textStyle: TextStyle(fontFamily: 'ONE Mobile Title'))),
      home: CupertinoPageScaffold(
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (_, state) {
            if (state is Empty) {
              return Container();
            } else if (state is Error) {
              return Text(state.message);
            } else if (state is Loading) {
              //return const Center(child: CupertinoActivityIndicator()); // iphone style
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: CircularProgressIndicator()),
                  SizedBox(height: 20),
                  Text('날시 정보를 불러오는 중 입니다.')
                ],
              ); //android style
            } else if (state is Loaded) {
              final WeatherViewModel viewModel =
                  state.weather[0] as WeatherViewModel;

              return Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.black12.withOpacity(0.5), BlendMode.dstATop),
                        image: const AssetImage('assets/images/background.jpg'),
                        fit: BoxFit.cover)),
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      pinned: true,
                      stretch: true,
                      centerTitle: false,
                      toolbarHeight: 100.0,
                      expandedHeight: 300.0,
                      flexibleSpace: FlexibleSpaceBar(
                        background: TodayWidget(
                          img: viewModel.weatherImage,
                          title: viewModel.region,
                          now: viewModel.curTemperature,
                          min: viewModel.minTemperature,
                          max: viewModel.maxTemperature,
                        ),
                      ),
                    ),
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      stretch: false,
                      pinned: false,
                      bottom: const PreferredSize(
                          child: SizedBox(height: 16,),
                          preferredSize: Size.fromHeight(100.0)),
                      flexibleSpace: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Column(
                          children: [
                            Text(
                              '${getToday()} 시간 별 예보',
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 12),
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
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                      (context, index) {

                        return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ListitemByDay(
                                title: viewModel.itemByDay[index].title,
                                img : viewModel.itemByDay[index].weatherImage,
                                min : viewModel.itemByDay[index].minTemperature,
                                max : viewModel.itemByDay[index].maxTemperature
                            )
                        );
                      },
                      childCount: viewModel.itemByDay.length,
                    ))
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
