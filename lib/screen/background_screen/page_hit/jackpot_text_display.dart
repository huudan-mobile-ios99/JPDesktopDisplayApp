import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';

class JackpotTextDisplay extends StatelessWidget {
  final String number;
  final String value;

  const JackpotTextDisplay({
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

    return Stack(
      children: [
        Positioned(
          left: ConfigCustom.text_hit_price_dX_1920x1080_ledFloor3Mega * scaleX,
          top: ConfigCustom.text_hit_price_dY_1920x1080_ledFloor3Mega * scaleY,
          child: Text(
            priceText,
            style: TextStyle(
              fontSize: ConfigCustom.text_hit_price_size_1920x1080_ledFloor3Mega * scale,
              color: Colors.white,
              fontFamily: 'sf-pro-display',
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            textScaleFactor: 1.0,
          ),
        ),
        Positioned(
          left: ConfigCustom.text_hit_number_dX_1920x1080_ledFloor3Mega * scaleX,
          top: ConfigCustom.text_hit_number_dY_1920x1080_ledFloor3Mega * scaleY,
          child: Text(
            '#${number}',
            style: TextStyle(
              fontSize: ConfigCustom.text_hit_price_size_1920x1080_ledFloor3Mega * scale,
              color: Colors.white,
              fontFamily: 'sf-pro-display',
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            textScaleFactor: 1.0,
          ),
        ),
      ],
    );
  }
}