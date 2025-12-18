 import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';

Widget screenLedATM(BuildContext context, Map<String, double> hiveValues,Map<String, double> prev,Map<String, double> value) {
    return Stack(
      //7 price vegas monthly weekly tripple dozen
      children: [
         Positioned(
          top: ConfigCustom.jp_vegas_screen_dY_ledATM,
          left: ConfigCustom.jp_vegas_screen_dX_ledATM,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagVegas,
            valueKey: ConfigCustom.tagVegas,
            hiveValue: hiveValues[ConfigCustom.tagVegas] ?? 0.0,
            isSmall: false,
          ),
        ),
        Positioned(
          top: ConfigCustom.jp_monthly_screen_dY_ledATM,
          left: ConfigCustom.jp_monthly_screen_dX_ledATM,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagMonthly,
            valueKey: ConfigCustom.tagMonthly,
            hiveValue: hiveValues[ConfigCustom.tagMonthly] ?? 0.0,
            isSmall: false,
          ),
        ),
         Positioned(
          top: ConfigCustom.jp_weekly_screen_dY_ledATM,
          left: ConfigCustom.jp_weekly_screen_dX_ledATM,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagWeekly,
            valueKey: ConfigCustom.tagWeekly,
            hiveValue: hiveValues[ConfigCustom.tagWeekly] ?? 0.0,
            isSmall: false,
          ),
        ),

        Positioned(
          top: ConfigCustom.jp_tripple_screen_dY_ledATM,
          left: ConfigCustom.jp_tripple_screen_dX_ledATM,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagTriple,
            valueKey: ConfigCustom.tagTriple,
            hiveValue: hiveValues[ConfigCustom.tagTriple] ?? 0.0,
            isSmall: false,
          ),
        ),
        Positioned(
          top: ConfigCustom.jp_dozen_screen_dY_ledATM,
          left: ConfigCustom.jp_dozen_screen_dX_ledATM,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagDozen,
            valueKey: ConfigCustom.tagDozen,
            hiveValue: hiveValues[ConfigCustom.tagDozen] ?? 0.0,
            isSmall: false,
          ),
        ),
        Positioned(
          top: ConfigCustom.jp_dailygolden_screen_dY_ledATM,
          left: ConfigCustom.jp_dailygolden_screen_dX_ledATM,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagDailyGolden,
            valueKey: ConfigCustom.tagDailyGolden,
            hiveValue: hiveValues[ConfigCustom.tagDailyGolden] ?? 0.0,
            isSmall: false,
          ),
        ),
       
       
      ],
    );
  }

