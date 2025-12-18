 import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/jackpot_screen_page.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';

Widget screenRLFloor2(BuildContext context, Map<String, double> hiveValues,Map<String, double> prev,Map<String, double> value) {
    return Stack(
      //7 price vegas monthly weekly tripple dozen
      children: [
         Positioned(
          top: ConfigCustom.jp_vegasSpin_screen_dY_ledRLFloor2,
          left: ConfigCustom.jp_vegasSpin_screen_dX_ledRLFloor2,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagVegasSpinJP2,
            valueKey: ConfigCustom.tagVegasSpinJP,
            hiveValue: hiveValues[ConfigCustom.tagVegasSpinJP] ?? 0.0,
            isSmall: false,
          ),
        ),
        
        Positioned(
          top: ConfigCustom.jp_grandSpin_screen_dY_ledRLFloor2,
          left: ConfigCustom.jp_grandSpin_screen_dX_ledRLFloor2,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagGrandSpinJP2,
            valueKey: ConfigCustom.tagGrandSpinJP,
            hiveValue: hiveValues[ConfigCustom.tagGrandSpinJP] ?? 0.0,
            isSmall: false,
          ),
        ),
         Positioned(
          top: ConfigCustom.jp_majorSpin_screen_dY_ledRLFloor2,
          left: ConfigCustom.jp_majorSpin_screen_dX_ledRLFloor2,
          child: JackpotOdometer(
            nameJP: ConfigCustom.tagMajorSpinJP2,
            valueKey: ConfigCustom.tagMajorSpinJP,
            hiveValue: hiveValues[ConfigCustom.tagMajorSpinJP] ?? 0.0,
            isSmall: false,
          ),
        ),
      ],
    );
  }

