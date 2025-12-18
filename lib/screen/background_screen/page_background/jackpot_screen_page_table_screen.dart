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

class JackpotDisplayScreenTableBCScreen extends StatefulWidget {
  const JackpotDisplayScreenTableBCScreen({super.key});

  @override
  State<JackpotDisplayScreenTableBCScreen> createState() => _JackpotDisplayScreenTableBCScreenState();
}

class _JackpotDisplayScreenTableBCScreenState extends State<JackpotDisplayScreenTableBCScreen> {
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

                return Center(
                  child: priceState.isConnected
                      ?
                      SizedBox(
                          // color:Colors.blue.shade100,
                          width: ConfigCustom.fixWidthContent_table,
                          height: ConfigCustom.fixHeightContent_table,
                          child: screenAllFixedHeight(context, hiveValues),
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
  Widget screenAllFixedHeight(BuildContext context, Map<String, double> hiveValues) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //row 1
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment:CrossAxisAlignment.center,
          children: [
             JackpotOdometer(
               nameJP: ConfigCustom.tagVegas,
               valueKey: ConfigCustom.tagVegas,
               hiveValue: hiveValues[ConfigCustom.tagVegas] ?? 0.0,
               isSmall: false,
             ),
             JackpotOdometer(
               nameJP: ConfigCustom.tagMonthly,
               valueKey: ConfigCustom.tagMonthly,
               hiveValue: hiveValues[ConfigCustom.tagMonthly] ?? 0.0,
               isSmall: false,
             ),
             JackpotOdometer(
               nameJP: ConfigCustom.tagWeekly,
               valueKey: ConfigCustom.tagWeekly,
               hiveValue: hiveValues[ConfigCustom.tagWeekly] ?? 0.0,
               isSmall: false,
             ),
          ],
        ),
        const SizedBox(height:28),
        //row 2
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment:CrossAxisAlignment.center,
          children: [
             JackpotOdometer(
               nameJP: ConfigCustom.tagTriple,
               valueKey: ConfigCustom.tagTriple,
               hiveValue: hiveValues[ConfigCustom.tagTriple] ?? 0.0,
               isSmall: false,
             ),
             JackpotOdometer(
               nameJP: ConfigCustom.tagDozen,
               valueKey: ConfigCustom.tagDozen,
               hiveValue: hiveValues[ConfigCustom.tagDozen] ?? 0.0,
               isSmall: false,
             ),
             JackpotOdometer(
               nameJP: ConfigCustom.tagDailyGolden2,
               valueKey: ConfigCustom.tagDailyGolden,
               hiveValue: hiveValues[ConfigCustom.tagDailyGolden] ?? 0.0,
               isSmall: false,
             ),
          ],
        ),
      ],
    );
  }

}
