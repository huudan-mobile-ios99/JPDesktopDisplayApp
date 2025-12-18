import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';

class JackpotTextDisplayFull extends StatelessWidget {
  final String number;
  final String value;

  const JackpotTextDisplayFull({
    super.key,
    required this.number,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double scaleX = screenSize.width / 1920.0;
    final double scaleY = screenSize.height / 1080.0;
    final double scale = math.min(scaleX, scaleY);
    final NumberFormat numberFormat = NumberFormat('#,##0.00', 'en_US');
    final priceText = (value == '0.00' || value == '0' || value == '0.0')
        ? ''
        : '\$${numberFormat.format(num.parse(value))}';
  
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
         Text(
            "CONGRATULATION",
            style: TextStyle(
              fontSize: ConfigCustom.text_hit_price_size_1920x1080_ledFloor3MegaFull * scale,
              color: Colors.white,
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
              fontSize: ConfigCustom.text_hit_price_size_1920x1080_ledFloor3MegaFull * scale,
              color: Colors.white,
              fontFamily: 'sf-pro-display',
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            textScaleFactor: 1.0,
          ),
        const SizedBox(width: 5*24,),
        Text(
            'WIN: $priceText',
            style: TextStyle(
              fontSize: ConfigCustom.text_hit_price_size_1920x1080_ledFloor3MegaFull * scale,
              color: Colors.white,
              fontFamily: 'sf-pro-display',
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            textScaleFactor: 1.0,
          ),
      ],
    );

    
  }
}