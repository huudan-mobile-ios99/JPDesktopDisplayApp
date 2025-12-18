 import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';

Widget screenCustomTripleDaily(BuildContext context, Map<String, double> hiveValues,Map<String, double> prev,Map<String, double> value) {
    return Stack(
      //2 price only triple and daily
      children: [
         Positioned(
          top: ConfigCustom.jp_triple_screen_dY_ledCustomTRIPLEDAILY,
          left: ConfigCustom.jp_triple_screen_dX_ledCustomTRIPLEDAILY,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagTriple,
            valueKey: ConfigCustom.tagTriple,
            hiveValue: hiveValues[ConfigCustom.tagTriple] ?? 0.0,
            isSmall: false,
          ),
        ),
        
        Positioned(
          top: ConfigCustom.jp_dailygolden_screen_dY_ledCustomTRIPLEDAILY,
          left: ConfigCustom.jp_dailygolden_screen_dX_ledCustomTRIPLEDAILY,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagDailyGolden2,
            valueKey: ConfigCustom.tagDailyGolden,
            hiveValue: hiveValues[ConfigCustom.tagDailyGolden] ?? 0.0,
            isSmall: false,
          ),
        ),
        Positioned(
          top: ConfigCustom.jp_frequent_screen_dY_ledCustomTRIPLEDAILY,
          left: ConfigCustom.jp_frequent_screen_dX_ledCustomTRIPLEDAILY,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagFrequent,
            valueKey: ConfigCustom.tagFrequent,
            hiveValue: hiveValues[ConfigCustom.tagFrequent] ?? 0.0,
            isSmall: false,
          ),
        ),
      ],
    );
  }

