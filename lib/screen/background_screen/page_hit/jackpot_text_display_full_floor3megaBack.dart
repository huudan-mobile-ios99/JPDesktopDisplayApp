import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:playtech_transmitter_app/service/color_custom.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';

class JackpotTextDisplayFullFloor3MegaBack extends StatelessWidget {
  final String number;
  final String value;

  const JackpotTextDisplayFullFloor3MegaBack({
    super.key,
    required this.number,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    // final double scaleX = screenSize.width /ConfigCustom.fixWidth_HD_led_Floor3MegaBack;
    // final double scaleY = screenSize.height / ConfigCustom.fixHeight_HD_led_Floor3MegaBack;
    // final double scale = math.min(scaleX, scaleY);
    final NumberFormat numberFormat = NumberFormat('#,##0.00', 'en_US');
    final priceText = (value == '0.00' || value == '0' || value == '0.0')
        ? ''
        : '\$${numberFormat.format(num.parse(value))}';
  
    return Container(
      width: ConfigCustom.fixWidth_HD_led_Floor3MegaBack,
      child: Row(
        mainAxisSize: MainAxisSize.max, // shrink to fit content
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
              "CONGRATULATION",
              style: TextStyle(
                fontSize: ConfigCustom.text_hit_price_size_1920x1080_ledFloor3MegaBACK ,
                color: ColorCustom.yellowMain,
                fontFamily: 'sf-pro-display',
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              textScaleFactor: 1.0,
            ),
          const SizedBox(width: 5*24,),
          Text(
              'MC: #$number',
              style: TextStyle(
                fontSize: ConfigCustom.text_hit_price_size_1920x1080_ledFloor3MegaBACK,
                color: ColorCustom.yellowMain,
                fontFamily: 'sf-pro-display',
                fontWeight: FontWeight.w600,
              ),
              // textAlign: TextAlign.center,
              textScaleFactor: 1.0,
            ),
          const SizedBox(width: 5*24,),
          Text(
              'WIN: $priceText',
              style: TextStyle(
                fontSize: ConfigCustom.text_hit_price_size_1920x1080_ledFloor3MegaBACK ,
                color: ColorCustom.yellowMain,
                fontFamily: 'sf-pro-display',
                fontWeight: FontWeight.w600,
              ),
              // textAlign: TextAlign.center,
              textScaleFactor: 1.0,
            ),
          const SizedBox(width: 10*24,)
        ],
      ),
    );

    
  }
}