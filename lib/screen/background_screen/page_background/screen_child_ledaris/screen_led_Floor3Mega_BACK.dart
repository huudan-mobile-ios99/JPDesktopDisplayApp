 import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';

Widget screenLedFloor3Mega_BACK(BuildContext context, Map<String, double> hiveValues,Map<String, double> prev,Map<String, double> value) {
    return Stack(
      //9 price vegas monthly weekly tripple dozen
      children: [
         Positioned(
          top: ConfigCustom.jp_vegas_screen_dY_ledFloor3MegaBACK,
          left: ConfigCustom.jp_vegas_screen_dX_ledFloor3MegaBACK,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagVegas,
            valueKey: ConfigCustom.tagVegas,
            hiveValue: hiveValues[ConfigCustom.tagVegas] ?? 0.0,
            isSmall: false,
          ),
        ),
        Positioned(
          top: ConfigCustom.jp_monthly_screen_dY_ledFloor3MegaBACK,
          left: ConfigCustom.jp_monthly_screen_dX_ledFloor3MegaBACK,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagMonthly,
            valueKey: ConfigCustom.tagMonthly,
            hiveValue: hiveValues[ConfigCustom.tagMonthly] ?? 0.0,
            isSmall: false,
          ),
        ),
         Positioned(
          top: ConfigCustom.jp_weekly_screen_dY_ledFloor3MegaBACK,
          left: ConfigCustom.jp_weekly_screen_dX_ledFloor3MegaBACK,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagWeekly,
            valueKey: ConfigCustom.tagWeekly,
            hiveValue: hiveValues[ConfigCustom.tagWeekly] ?? 0.0,
            isSmall: false,
          ),
        ),

        Positioned(
          top: ConfigCustom.jp_tripple_screen_dY_ledFloor3MegaBACK,
          left: ConfigCustom.jp_tripple_screen_dX_ledFloor3MegaBACK,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagTriple,
            valueKey: ConfigCustom.tagTriple,
            hiveValue: hiveValues[ConfigCustom.tagTriple] ?? 0.0,
            isSmall: false,
          ),
        ),

        Positioned(
          top: ConfigCustom.jp_dozen_screen_dY_ledFloor3MegaBACK,
          left: ConfigCustom.jp_dozen_screen_dX_ledFloor3MegaBACK,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagDozen,
            valueKey: ConfigCustom.tagDozen,
            hiveValue: hiveValues[ConfigCustom.tagDozen] ?? 0.0,
            isSmall: false,
          ),
        ),
        Positioned(
          top: ConfigCustom.jp_highlimit_screen_dY_ledFloor3MegaBACK,
          left: ConfigCustom.jp_highlimit_screen_dX_ledFloor3MegaBACK,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagHighLimitNEW2,
            valueKey: ConfigCustom.tagHighLimitNEW,
            hiveValue: hiveValues[ConfigCustom.tagHighLimitNEW] ?? 0.0,
            isSmall: false,
          ),
        ),
        Positioned(
          top: ConfigCustom.jp_dailygolden_screen_dY_ledFloor3MegaBACK,
          left: ConfigCustom.jp_dailygolden_screen_dX_ledFloor3MegaBACK,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagDailyGolden,
            valueKey: ConfigCustom.tagDailyGolden,
            hiveValue: hiveValues[ConfigCustom.tagDailyGolden] ?? 0.0,
            isSmall: false,
          ),
        ),
        Positioned(
          top: ConfigCustom.jp_daily_screen_dY_ledFloor3MegaBACK,
          left: ConfigCustom.jp_daily_screen_dX_ledFloor3MegaBACK,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagDaily,
            valueKey: ConfigCustom.tagDaily,
            hiveValue: hiveValues[ConfigCustom.tagDaily] ?? 0.0,
            isSmall: false,
          ),
        ),
        Positioned(
          top: ConfigCustom.jp_frequent_screen_dY_ledFloor3MegaBACK,
          left: ConfigCustom.jp_frequent_screen_dX_ledFloor3MegaBACK,
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

