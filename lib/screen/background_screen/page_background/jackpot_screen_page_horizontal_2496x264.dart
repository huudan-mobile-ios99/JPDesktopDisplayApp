import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/main/jackpot_price_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/main/jackpot_price_state.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc/video_bloc.dart';
import 'package:logger/logger.dart';
import 'package:playtech_transmitter_app/service/hive_service/jackpot_hive_service.dart';
import 'package:playtech_transmitter_app/service/widget/circlar_progress.dart';

class JackpotDisplayScreen2496x624 extends StatefulWidget {
  const JackpotDisplayScreen2496x624({super.key});

  @override
  State<JackpotDisplayScreen2496x624> createState() => _JackpotDisplayScreen2496x624State();
}

class _JackpotDisplayScreen2496x624State extends State<JackpotDisplayScreen2496x624> {
  final Logger _logger = Logger();
  late Future<Map<String, double>> _hiveValuesFuture;

  @override
  void initState() {
    super.initState();
    // Fetch Hive data once on initialization
    _hiveValuesFuture = JackpotHiveService().getJackpotHistory().then((state) => state.first);
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: _hiveValuesFuture,
      builder: (context, snapshot) {
        Map<String, double> hiveValues = {};
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          hiveValues = snapshot.data!;
        } else if (snapshot.hasError) {
          _logger.e('Error loading Hive data: ${snapshot.error}');
        }

        return BlocBuilder<VideoBloc, ViddeoState>(
          buildWhen: (previous, current) => previous.id != current.id,
          builder: (context, state) {
            return BlocBuilder<JackpotPriceBloc, JackpotPriceState>(
              buildWhen: (previous, current) =>
                  previous.isConnected != current.isConnected ||
                  previous.error != current.error ||
                  previous.jackpotValues != current.jackpotValues ||
                  previous.previousJackpotValues != current.previousJackpotValues,
              builder: (context, priceState) {
                // _logger.i('Building JackpotDisplayScreen: ${priceState.jackpotValues}');
                return Center(
                  child: priceState.isConnected
                      ?
                      SizedBox(
                          width: ConfigCustom.fixWidth_led_vms,
                          height: ConfigCustom.fixHeight_led_vms,
                          child: screenHorizontal2496x624(context, hiveValues),
                        )
                      :
                      priceState.error != null ? Container() : circularProgessCustom()
                );
              },
            );
          },
        );
      },
    );
  }
  Widget screenHorizontal2496x624(BuildContext context, Map<String, double> hiveValues) {
    return Stack(
      children: [
        //ROW ABOVE
         Positioned(
          top: ConfigCustom.jp_vegas_2496x624_dY,
          right: ConfigCustom.jp_vegas_2496x624_dX,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagVegas,
            valueKey: ConfigCustom.tagVegas,
            hiveValue: hiveValues[ConfigCustom.tagVegas] ?? 0.0,
            isSmall: false,
          ),
        ),
        Positioned(
          top: ConfigCustom.jp_monthly_2496x624_dY,
          left: ConfigCustom.jp_monthly_2496x624_dX,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagMonthly,
            valueKey: ConfigCustom.tagMonthly,
            hiveValue: hiveValues[ConfigCustom.tagMonthly] ?? 0.0,
            isSmall: false,
          ),
        ),
         Positioned(
          top: ConfigCustom.jp_weekly_2496x624_dY,
          left: ConfigCustom.jp_weekly_2496x624dX,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagWeekly,
            valueKey: ConfigCustom.tagWeekly,
            hiveValue: hiveValues[ConfigCustom.tagWeekly] ?? 0.0,
            isSmall: false,
          ),
        ),
        Positioned(
          top: ConfigCustom.jp_tripple_2496x624_dY,
          left: ConfigCustom.jp_tripple_2496x624_dX,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagTriple,
            valueKey: ConfigCustom.tagTriple,
            hiveValue: hiveValues[ConfigCustom.tagTriple] ?? 0.0,
            isSmall: false,
          ),
        ),
        Positioned(
          top: ConfigCustom.jp_dozen_2496x624_dY,
          left: ConfigCustom.jp_dozen_2496x624_dX,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagDozen,
            valueKey: ConfigCustom.tagDozen,
            hiveValue: hiveValues[ConfigCustom.tagDozen] ?? 0.0,
            isSmall: false,
          ),
        ),



        //ROW BELOW
        Positioned(
          top: ConfigCustom.jp_dailygolden_2496x624_dY,
          right: ConfigCustom.jp_dailygolden_2496x624_dX,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagDailyGolden,
            valueKey: ConfigCustom.tagDailyGolden,
            hiveValue: hiveValues[ConfigCustom.tagDailyGolden] ?? 0.0,
            isSmall: false,
          ),
        ),
        Positioned(
          top: ConfigCustom.jp_daily_2496x624_dY,
          left: ConfigCustom.jp_daily_2496x624_dX,
          child: JackpotOdometer(
            nameJP:ConfigCustom.tagDaily ,
            valueKey: ConfigCustom.tagDaily,
            hiveValue: hiveValues[ConfigCustom.tagDaily] ?? 0.0,
            isSmall: false,
          ),
        ),
        Positioned(
          top: ConfigCustom.jp_frequent_2496x624_dY,
          left: ConfigCustom.jp_frequent_2496x624_dX,
          child:
           JackpotOdometer(
            nameJP: ConfigCustom.tagFrequent,
            valueKey: ConfigCustom.tagFrequent,
            hiveValue: hiveValues[ConfigCustom.tagFrequent] ?? 0.0,
            isSmall: false,
          ),
        ),

      ],
    );
  }

}
