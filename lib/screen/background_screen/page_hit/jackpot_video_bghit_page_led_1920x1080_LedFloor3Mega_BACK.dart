import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_text_display.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_text_display_full.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_text_display_full_floor3megaBack.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/service/widget/text_style.dart';

class JackpotBackgroundVideoHit1920x1080LedFloor3MegaBACK extends StatefulWidget {
  final String number;
  final String value;
  final String id;

  const JackpotBackgroundVideoHit1920x1080LedFloor3MegaBACK({
    super.key,
    required this.number,
    required this.value,
    required this.id,
  });

  @override
  _JackpotBackgroundVideoHit1920x1080LedFloor3MegaBACKState createState() => _JackpotBackgroundVideoHit1920x1080LedFloor3MegaBACKState();
}




class _JackpotBackgroundVideoHit1920x1080LedFloor3MegaBACKState extends State<JackpotBackgroundVideoHit1920x1080LedFloor3MegaBACK>
   {
  final NumberFormat _numberFormat = NumberFormat('#,##0.00', 'en_US');


  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(JackpotBackgroundVideoHit1920x1080LedFloor3MegaBACK oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;

    return
    SizedBox(
      width: ConfigCustom.fixWidth_HD_led_Floor3MegaBack,
      height: ConfigCustom.fixHeight_HD_led_Floor3MegaBack, // Full screen container
      child: Stack(
        // fit: StackFit.expand,
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(
          //   height: ConfigCustom.fixWidth_HD_led_Floor3MegaBack/7,
          // ),
          Positioned(
            top: ConfigCustom.fixHeight_HD_led_Floor3MegaBack/3.25,
            left:ConfigCustom.fixHeight_HD_led_Floor3MegaBack/2.45,
            child: JackpotTextDisplayFullFloor3MegaBack(
                number: widget.number,
                value: widget.value,
            ),
          ),
        ],
      ),
    );
  }
}



